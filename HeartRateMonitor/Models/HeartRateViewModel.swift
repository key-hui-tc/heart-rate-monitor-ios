//
//  HeartRateViewModel.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 29/10/2021.
//

import SwiftUI
import Foundation
import AVFoundation
import UIKit

typealias ImageBufferHandler = ((_ imageBuffer: CMSampleBuffer) -> ())

final class HeartRateViewModel: NSObject, ObservableObject {
    @Published var validFrameCounter = 0
    @Published var hueFilter = Filter()
    @Published var pulseDetector = PulseDetector()
    @Published var inputs: [CGFloat] = []
    @Published var measurementStartedFlag = false
    @Published var timer = Timer()

    private let preferredSpec = VideoSpec(fps: 30, size: CGSize(width: 300, height: 300))
    private let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice!
    private var videoConnection: AVCaptureConnection!
    private var audioConnection: AVCaptureConnection!
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var imageBufferHandler: ImageBufferHandler?

    init(cameraType: CameraType = .back, previewContainer: CALayer? = nil) {
        super.init()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("has camera")
        } else {
            print("no camera")
            return
        }

        videoDevice = cameraType.captureDevice()

        // MARK: - Setup Video Format
        do {
            captureSession.sessionPreset = .low
            videoDevice.updateFormatWithPreferredVideoSpec(preferredSpec: preferredSpec)
        }

        // MARK: - Setup video device input
        let videoDeviceInput: AVCaptureDeviceInput
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch let error {
            fatalError("Could not create AVCaptureDeviceInput instance with error: \(error).")
        }
        guard captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        captureSession.addInput(videoDeviceInput)

        // MARK: - Setup preview layer
        if let previewContainer = previewContainer {
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = previewContainer.bounds
            previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewContainer.insertSublayer(previewLayer, at: 0)
            self.previewLayer = previewLayer
        }

        // MARK: - Setup video output
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey: NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        let queue = DispatchQueue(label: "key.tc.queue")
        videoDataOutput.setSampleBufferDelegate(self, queue: queue)
        guard captureSession.canAddOutput(videoDataOutput) else {
            fatalError()
        }
        captureSession.addOutput(videoDataOutput)
        videoConnection = videoDataOutput.connection(with: .video)
    }

    func getSession() -> AVCaptureSession {
        return captureSession
    }

    func startCapture() {
        if captureSession.isRunning {
            print("Capture Session is already running.")
            return
        }
        captureSession.startRunning()
    }

    func stopCapture() {
        if !captureSession.isRunning {
            print("Capture Session has already stopped.")
            return
        }
        captureSession.stopRunning()
    }
}

extension HeartRateViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    // MARK: - Export buffer from video frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if connection.videoOrientation != .portrait {
            connection.videoOrientation = .portrait
            return
        }
        if let imageBufferHandler = imageBufferHandler {
            imageBufferHandler(sampleBuffer)
        }
    }
}
