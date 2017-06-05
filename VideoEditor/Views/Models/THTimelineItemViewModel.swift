//
//  THTimelineItemViewModel.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

class THTimelineItemViewModel: NSObject {
    
    let TIMELINE_SECONDS = 30
    let TIMELINE_WIDTH = 2014
    
    var widthInTimeline: CGFloat? = 0
    var maxWidthInTimeline: CGFloat?
    var positionInTimeline: CGPoint? = CGPoint(x: 0, y: 0)
    var timelineItem: THTimelineItem?
    
    static func model(withTimelineItem timelineItem: THTimelineItem) -> THTimelineItemViewModel {
        return THTimelineItemViewModel(withTimelineItem: timelineItem)
    }
    
    func THGetWidthForTimeRange(timeRange: CMTimeRange, scaleFactor: CGFloat) -> CGFloat {
        return CGFloat(CMTimeGetSeconds(timeRange.duration)) * scaleFactor
    }
    
    func THGetOriginForTime(time: CMTime) -> CGPoint {
        let seconds = CMTimeGetSeconds(time)
        return CGPoint(x: CGFloat(seconds) * CGFloat(TIMELINE_WIDTH / TIMELINE_SECONDS), y: 0)
    }
    
    func THGetTimeRangeForWidth(width: CGFloat, scaleFactor: CGFloat) -> CMTimeRange {
        let duration = width / scaleFactor
        return CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(Float64(duration), Int32(scaleFactor)))
    }
    
    func THGetTimeForOrigin(origin: CGFloat, scaleFactor: CGFloat) -> CMTime {
        let seconds = origin / scaleFactor
        return CMTimeMakeWithSeconds(Float64(seconds), Int32(scaleFactor))
    }
    init(withTimelineItem timelineItem: THTimelineItem) {
        super.init()
        self.timelineItem = timelineItem
        let maxTimeRange = CMTimeRangeMake(kCMTimeZero, timelineItem.timeRange.duration)
        self.maxWidthInTimeline = THGetWidthForTimeRange(timeRange: maxTimeRange, scaleFactor: CGFloat(TIMELINE_WIDTH / TIMELINE_SECONDS))
    }
    
    func updateTimelineItem() {
        if (self.positionInTimeline?.x)! > CGFloat(0.0) {
            let startTime = THGetTimeForOrigin(origin: (self.positionInTimeline?.x)!, scaleFactor: CGFloat(TIMELINE_WIDTH / TIMELINE_SECONDS))
            self.timelineItem?.startTimeInTimeLine = startTime
        }
        
        self.timelineItem?.timeRange = THGetTimeRangeForWidth(width: self.widthInTimeline!, scaleFactor: CGFloat(TIMELINE_WIDTH / TIMELINE_SECONDS))
    }
    
    func getWidthInTimeline() -> CGFloat {
        if self.widthInTimeline == nil || self.widthInTimeline == 0.0 {
            self.widthInTimeline = THGetWidthForTimeRange(timeRange: (self.timelineItem?.timeRange)!, scaleFactor: CGFloat(TIMELINE_WIDTH / TIMELINE_SECONDS))
        }
        return self.widthInTimeline!
    }
}
