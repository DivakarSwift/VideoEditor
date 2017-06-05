//
//  THBasicCompositionBuilder.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import AVFoundation

class THBasicCompositionBuilder: NSObject, THCompositionBuilder {
    var timeline: THTimeline?
    var composition: AVMutableComposition?
    
    init(withTimeline timeline: THTimeline) {
        super.init()
        self.timeline = timeline
    }
    
    func buildComposition() -> THComposition {
        self.composition = AVMutableComposition()
        self.addCompositionTrackOfType(mediaType: AVMediaTypeVideo, mediaItems: (self.timeline?.videos)!)
        self.addCompositionTrackOfType(mediaType: AVMediaTypeAudio, mediaItems: (self.timeline?.voiceOvers)!)
        self.addCompositionTrackOfType(mediaType: AVMediaTypeAudio, mediaItems: (self.timeline?.musicItems)!)
        
        return THBasicComposition(withComposition: self.composition!)
    }
    
    func addCompositionTrackOfType(mediaType: String, mediaItems: Array<THMediaItem>) {
        if mediaItems.count != 0 {
            let compositionTrack = self.composition?.addMutableTrack(withMediaType: mediaType, preferredTrackID: kCMPersistentTrackID_Invalid)
            var cursorTime = kCMTimeZero
            for item in mediaItems {
                if item.startTimeInTimeLine != kCMTimeInvalid {
                    cursorTime = item.startTimeInTimeLine
                }
                let assetTrack = item.asset?.tracks(withMediaType: mediaType)[0]
                try! compositionTrack?.insertTimeRange(item.timeRange, of: assetTrack!, at: cursorTime)
                cursorTime = CMTimeAdd(cursorTime, item.timeRange.duration)
            }
        }
    }
}
