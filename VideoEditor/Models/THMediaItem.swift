//
//  THMediaItem.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

public typealias THPreparationCompletionBlock = (_ complete: Bool) -> Swift.Void

class THMediaItem: THTimelineItem {
    let AVAssetTracksKey = "tracks"
    let AVAssetDurationKey = "duration"
    let AVAssetCommonMetadataKey = "commonMetadata"
    
    var asset: AVAsset?
    var prepared: Bool? = false
    var mediaType: String? {
            assert(false, "Must be overidden in subclass.")
            return nil
    }
    private var title: String? = ""
    func getTitle() -> String {
        if title == nil || (title?.isEmpty)! {
            for metaItem in (self.asset?.commonMetadata)! {
                if metaItem.commonKey == AVMetadataCommonKeyTitle {
                    title = metaItem.stringValue
                    break
                }
            }
        }
        
        if title == nil {
            title = self.filename
        }
        return title!
    }
    
    var url: URL?
    var filename: String? = ""
    
    init(withURL url: URL) {
        super.init()
        self.url = url
        self.filename = url.lastPathComponent
        self.asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey : true])
    }
    
    func prepare(_ completion: THPreparationCompletionBlock?) {
        if self.asset == nil {
            return
        }
        
        self.asset?.loadValuesAsynchronously(forKeys: [AVAssetTracksKey, AVAssetDurationKey, AVAssetCommonMetadataKey], completionHandler: { 
            let tracksStatus = self.asset?.statusOfValue(forKey: self.AVAssetTracksKey, error: nil)
            let durationStatus = self.asset?.statusOfValue(forKey: self.AVAssetDurationKey, error: nil)
            self.prepared = (tracksStatus == AVKeyValueStatus.loaded) && (durationStatus == AVKeyValueStatus.loaded)
            if self.prepared! {
                self.timeRange = CMTimeRangeMake(kCMTimeZero, (self.asset?.duration)!)
                if completion != nil {
                    self.performPostPrepareActions(completion!)
                }
            }
            else if completion != nil {
                completion!(false)
            }
        })
    }
    
    func performPostPrepareActions(_ completion: THPreparationCompletionBlock?) {
        if completion != nil {
            completion!(self.prepared!)
        }
    }
    
    func isTrimmed() -> Bool {
        if !self.prepared! {
            return false
        }
        return self.timeRange.duration < (self.asset?.duration)!
    }
    
    func makePlayable() -> AVPlayerItem {
        return AVPlayerItem(asset: self.asset!)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if object == nil || !(object is THMediaItem) {
            return false
        }
        let other = object as! THMediaItem
        if self == other {
            return true
        }
        return self.url == other.url
    }
    
    override var hash: Int {
        get {
            return (self.url?.hashValue)!
        }
    }
}
