//
//  THAudioItem.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

class THAudioItem: THMediaItem {
    var volumeAutomation: [THVolumeAutomation]? = [THVolumeAutomation]()
    override var mediaType: String? {
        get {
            return AVMediaTypeAudio
        }
    }
    
    static func audioItem(withURL url: URL) -> THAudioItem {
        return THAudioItem(withURL: url)
    }
}
