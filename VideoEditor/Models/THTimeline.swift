//
//  THTimeline.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTimeline: NSObject {
    var videos: [THMediaItem]? = [THMediaItem]()
    var transitions: [THVideoTransition]? = [THVideoTransition]()
    var titles: [THCompositionLayer]? = [THCompositionLayer]()
    var voiceOvers: [THMediaItem]? = [THMediaItem]()
    var musicItems: [THAudioItem]? = [THAudioItem]()
    
    func isSimpleTileLine() -> Bool {
        for item in self.musicItems! {
            if (item.volumeAutomation?.count)! > 0 {
                return false
            }
        }
        if (self.transitions?.count)! > 0 || (self.titles?.count)! > 0 {
            return false
        }
        return true
    }
}
