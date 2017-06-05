//
//  THBasicComposition.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import AVFoundation

class THBasicComposition: NSObject, THComposition {
    var composition: AVComposition?
    var videoComposition: AVVideoComposition?
    var audioMix: AVAudioMix?
    var titleLayer: CALayer?
    
    static func composition(withComposition composition: AVComposition) -> THBasicComposition {
        return THBasicComposition(withComposition: composition)
    }
    
    init(withComposition composition: AVComposition) {
        super.init()
        self.composition = composition
    }
    
    func makePlayable() -> AVPlayerItem {
        return AVPlayerItem(asset: self.composition!)
    }
    
    func makeExportable() -> AVAssetExportSession {
        return AVAssetExportSession(asset: self.composition!, presetName: AVAssetExportPresetHighestQuality)!
    }
}
