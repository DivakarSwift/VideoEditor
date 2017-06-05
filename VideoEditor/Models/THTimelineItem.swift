//
//  THTimelineItem.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

class THTimelineItem: NSObject {
    var timeRange: CMTimeRange
    var startTimeInTimeLine: CMTime
    
    override init() {
        timeRange = kCMTimeRangeInvalid
        startTimeInTimeLine = kCMTimeInvalid
    }
}
