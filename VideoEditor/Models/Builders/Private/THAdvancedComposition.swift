//
//  THAdvancedComposition.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import AVFoundation

class THAdvancedComposition: THBasicComposition {
    
    static let VIDEO_SIZE = CGSize(width: 1280, height: 720)
    static let VIDEO_BOUNDS = CGRect(x: 0, y: 0, width: THAdvancedComposition.VIDEO_SIZE.width, height: THAdvancedComposition.VIDEO_SIZE.height)
    
    init(withComposition composition: AVComposition, videoComposition: AVVideoComposition, audioMix: AVAudioMix, titleLayer: CALayer) {
        super.init(withComposition: composition)
        self.videoComposition = videoComposition
        self.audioMix = audioMix
        self.titleLayer = titleLayer
    }
    
    override func makePlayable() -> AVPlayerItem {
        let playerItem = AVPlayerItem(asset: self.composition!)
        playerItem.videoComposition = self.videoComposition
        playerItem.audioMix = self.audioMix
        
        let synchLayer = AVSynchronizedLayer(playerItem: playerItem)
        synchLayer.bounds = THAdvancedComposition.VIDEO_BOUNDS
        synchLayer.addSublayer(self.titleLayer!)
        return playerItem
    }
    
    override func makeExportable() -> AVAssetExportSession {
        if self.titleLayer != nil {
            let parentLayer = self.createLayer()
            let videoLayer = self.createLayer()
            parentLayer.addSublayer(videoLayer)
            parentLayer.addSublayer(self.titleLayer!)
            self.titleLayer?.isGeometryFlipped = true
            
            let animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            (self.videoComposition as! AVMutableVideoComposition).animationTool = animationTool
        }
        
        let session = AVAssetExportSession(asset: self.composition!, presetName: AVAssetExportPreset1280x720)
        session?.audioMix = self.audioMix
        session?.videoComposition = self.videoComposition
        return session!
    }
    
    func createLayer() -> CALayer {
        let layer = CALayer()
        layer.frame = THAdvancedComposition.VIDEO_BOUNDS
        return layer
    }
}
