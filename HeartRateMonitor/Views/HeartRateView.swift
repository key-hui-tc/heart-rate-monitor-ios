//
//  HeartRateView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 28/10/2021.
//

import SwiftUI
import AVFoundation

struct HeartRateView: View {
    @StateObject private var vm = HeartRateViewModel()
    @State private var pulse: Float = 0
    @State private var pulseOpacity: Double = 0
    @State private var pulseIsHidden = true
    @State private var pulseMessage = ""
    @State private var message = ""
    @State private var isMeasurementStarted = false
    @State private var timer: Timer?

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

    private func resetMessages() {
        message = txtCover
        pulseMessage = ""
    }

    private func onAppear() {
        // reset ui
        resetMessages()

        // init video capture
        vm.imageBufferHandler = { imageBuffer in
            self.handle(buffer: imageBuffer)
        }

        // init capture session
        vm.startCapture()
    }

    private func onDisappear() {
        // deinit capture session
        vm.stopCapture()
        toggleTorch(status: false)
    }

    private func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }

    private func startMeasurement() {
        Task {
            toggleTorch(status: true)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
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

    private func stopMeasurement() {
        timer?.invalidate()
    }

    func handle(buffer: CMSampleBuffer) {
        let isPassed = vm.handle(buffer: buffer)
        if isPassed {
            message = txtHold
            toggleTorch(status: true)
            if !isMeasurementStarted {
                startMeasurement()
                isMeasurementStarted = true
            }
        } else {
            isMeasurementStarted = false
            stopMeasurement()
            resetMessages()
        }
    }

}
