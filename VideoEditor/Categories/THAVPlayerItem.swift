//
//  THAVPlayerItem.swift
//  VideoEditor
//
//  Created by Mobdev125 on 6/1/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import Foundation
import AVFoundation
import CoreMedia

var THSynchronizedLayerKey: Any?

extension AVPlayerItem {
    var titleLayer: AVSynchronizedLayer? {
        get {
            return objc_getAssociatedObject(self, &THSynchronizedLayerKey) as? AVSynchronizedLayer
        }
        set(titleLayer) {
            objc_setAssociatedObject(self, &THSynchronizedLayerKey, titleLayer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func hasValidDuration() -> Bool {
        return self.status == AVPlayerItemStatus.readyToPlay && !CMTIME_IS_VALID(self.duration)
    }
    
    func muteAudioTracks(value: Bool) {
        for track in self.tracks {
            if track.assetTrack.mediaType == AVMediaTypeAudio {
                track.isEnabled = !value
            }
        }
    }
    
}
