//
//  VideoPlayerView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/31/21.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let player = AVPlayer(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)

    init() {
        let url = Bundle.main.url(forResource: "demo", withExtension: "mp4")!
        let asset = AVAsset(url: url)
        let reader = try! AVAssetReader(asset: asset)
        let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        // read video frames as BGRA
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])

        reader.add(trackReaderOutput)
        reader.startReading()

        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
            print("sample at time \(CMSampleBufferGetPresentationTimeStamp(sampleBuffer))")
            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                Logger.d(imageBuffer)
            }
        }
    }

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}
