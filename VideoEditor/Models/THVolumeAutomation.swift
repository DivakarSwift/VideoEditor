//
//  THVolumeAutomation.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

class THVolumeAutomation: NSObject {
    var timeRange: CMTimeRange?
    var startVolume: Float?
    var endVolume: Float?
    
    static func volumeAutomation(withTimeRange timeRange: CMTimeRange, startVolume:Float, endVolume: Float) -> THVolumeAutomation {
        let automation = THVolumeAutomation()
        automation.timeRange = timeRange
        automation.startVolume = startVolume
        automation.endVolume = endVolume
        return automation
    }
}
