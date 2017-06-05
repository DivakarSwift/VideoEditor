//
//  THVideoItem.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

let THUMBNAIL_COUNT = 4

class THVideoItem: THMediaItem {
    
    let THUMBNAIL_SIZE = CGSize(width: 227.0, height: 128.0)
    
    var thumbnails: [UIImage]? = [UIImage]()
    var startTransition: THVideoTransition?
    var endTransition: THVideoTransition?
    var playthroughTimeRange: CMTimeRange? {
        get {
            var range = self.timeRange
            if self.startTransition != nil && self.startTransition?.type != THVideoTransitionType.none {
                range.start = CMTimeAdd(range.start, (self.startTransition?.duration)!)
                range.duration = CMTimeSubtract(range.duration, (self.startTransitionTimeRange?.duration)!)
            }
            if self.endTransition != nil && self.endTransition?.type != THVideoTransitionType.none {
                range.duration = CMTimeSubtract(range.duration, (self.endTransition?.duration)!)
            }
            return range
        }
    }
    var startTransitionTimeRange: CMTimeRange? {
        get {
            if self.startTransition != nil && self.startTransition?.type != THVideoTransitionType.none {
                return CMTimeRangeMake(kCMTimeZero, (self.startTransition?.duration)!)
            }
            return CMTimeRangeMake(kCMTimeZero, kCMTimeZero)
        }
    }
    var endTransitionTimeRange: CMTimeRange? {
        get {
            if self.endTransition != nil && self.endTransition?.type != THVideoTransitionType.none {
                return CMTimeRangeMake(kCMTimeZero, (self.endTransition?.duration)!)
            }
            return CMTimeRangeMake(kCMTimeZero, kCMTimeZero)
        }
    }
    
    override var mediaType: String? {
        get {
            return AVMediaTypeVideo
        }
    }
    
    var imageGenerator: AVAssetImageGenerator?
    
    override init(withURL url: URL) {
        super.init(withURL: url)
        imageGenerator = AVAssetImageGenerator(asset: self.asset!)
        imageGenerator?.appliesPreferredTrackTransform = true
        imageGenerator?.maximumSize = THUMBNAIL_SIZE
    }
    
    override func performPostPrepareActions(_ completion: THPreparationCompletionBlock?) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.generateThumbnails(completion)
            }
        }
    }
    
    func generateThumbnails(_ completion: THPreparationCompletionBlock?) {
        let duration = self.asset?.duration
        let intervalSeconds = (duration?.value)! / Int64(THUMBNAIL_COUNT)
        var time = kCMTimeZero
        for _ in 0..<THUMBNAIL_COUNT {
            self.thumbnails?.append(thumbnailFromVideo(time: time))
            time = CMTimeAdd(time, CMTimeMake(intervalSeconds, (duration?.timescale)!))
        }
        completion!(true)
    }
    
    func thumbnailFromVideo(time: CMTime) -> UIImage{
        do{
            let cgImage = try imageGenerator?.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage!)
            return uiImage
        }catch{
            
        }
        return UIImage()
    }
}
