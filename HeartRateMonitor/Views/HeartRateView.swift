//
//  HeartRateView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 28/10/2021.
//

import SwiftUI
import AVFoundation

struct HeartRateView: View {
    @StateObject var vm = HeartRateViewModel()
    @State var pulse: Float = 0
    @State var pulseOpacity: Double = 0
    @State var pulseIsHidden = true
    @State var pulseMessage = ""
    @State var message = ""

    private let txtHold = "Hold your index finger ☝️ still."
    private let txtCover = "Cover the back camera until the image turns red 🟥"

    var body: some View {
        VStack {
            CameraView(session: vm.getSession())
                .frame(width: 120, height: 120)
                .padding(.bottom, 20)
            Text(message)
                .font(.system(size: 14))
                .padding(.bottom, 10)
            if !pulseIsHidden {
                Text(pulseMessage)
                    .opacity(pulseOpacity)
                    .font(.system(size: 14))
            }
        }
            .padding()
            .onAppear {
            onAppear()
        }.onDisappear {
            onDisappear()
        }
    }
}

struct HeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView()
    }
}

extension HeartRateView {

    private func onAppear() {
        message = txtCover
        initVideoCapture()
        initCaptureSession()
    }

    private func onDisappear() {
        deinitCaptureSession()
    }

    private func initVideoCapture() {
        vm.imageBufferHandler = { imageBuffer in
            self.handle(buffer: imageBuffer)
        }
    }

    private func initCaptureSession() {
        vm.startCapture()
    }

    private func deinitCaptureSession() {
        vm.stopCapture()
        toggleTorch(status: false)
    }

    private func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }

    private func startMeasurement() {
        Task {
            self.toggleTorch(status: true)
            vm.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                let average = vm.pulseDetector.getAverage()
                let pulse = 60.0 / average
                if pulse == -60 {
                    UIView.animate(withDuration: 0.2, animations: {
                        pulseOpacity = 0
                    }) { finished in
                        pulseIsHidden = finished
                    }
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        pulseOpacity = 1.0
                    }) { _ in
                        pulseIsHidden = false
                        pulseMessage = "\(lroundf(pulse)) BPM"
                    }
                }
            })
        }
    }

    func handle(buffer: CMSampleBuffer) {
        var redMean: CGFloat = 0.0
        var greenMean: CGFloat = 0.0
        var blueMean: CGFloat = 0.0

        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)

        let extent = cameraImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let averageFilter = CIFilter(name: "CIAreaAverage",
                                     parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
        let outputImage = averageFilter.outputImage!

        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(outputImage, from: outputImage.extent)!

        let rawData: NSData = cgImage.dataProvider!.data!
        let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
        let bytes = UnsafeBufferPointer<UInt8>(start: pixels, count: rawData.length)
        var bgraIndex = 0
        for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
            switch bgraIndex {
            case 0:
                blueMean = CGFloat (pixel)
            case 1:
                greenMean = CGFloat (pixel)
            case 2:
                redMean = CGFloat (pixel)
            case 3:
                break
            default:
                break
            }
            bgraIndex += 1
        }

        let hsv = rgb2hsv((red: redMean, green: greenMean, blue: blueMean, alpha: 1.0))
        Logger.d(hsv)
        // Do a sanity check to see if a finger is placed over the camera
        if (hsv.1 > 0.5 && hsv.2 > 0.5) {
            Task {
                message = txtHold
                self.toggleTorch(status: true)
                if !vm.measurementStartedFlag {
                    startMeasurement()
                    vm.measurementStartedFlag = true
                }

                vm.validFrameCounter += 1
                vm.inputs.append(hsv.0)
                // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
                let filtered = vm.hueFilter.processValue(value: Double(hsv.0))
                if vm.validFrameCounter > 60 {
                    _ = vm.pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
                }
            }
        } else {
            Task {
                vm.validFrameCounter = 0
                vm.measurementStartedFlag = false
                vm.pulseDetector.reset()
                message = txtCover
            }
        }
    }

}
