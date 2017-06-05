//
//  THVideoTransition.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

enum THVideoTransitionType {
    case none
    case fadeIn
    case fadeOut
    case dissolve
    case push
}

enum THPushTransitionDirection {
    case leftToRight
    case rightToLeft
    case topToButton
    case bottomToTop
    case invalid
}

class THVideoTransition: NSObject {
    var type: THVideoTransitionType?
    var timeRange: CMTimeRange?
    var duration: CMTime?
    private var direction: THPushTransitionDirection?
    
    func setDirection(direction: THPushTransitionDirection) {
        if type == .push {
            self.direction = direction
        }
        else {
            self.direction = .invalid
            assert(false, "Direction can only be specified for a type == Push.")
        }
    }
    
    override init() {
        type = .none
        timeRange = kCMTimeRangeInvalid
        duration = kCMTimeZero
    }
    
    static func videoTransition() -> THVideoTransition {
        return THVideoTransition()
    }
    
    static func fadeInTransitionWithDuration(duration: CMTime) -> THVideoTransition {
        let transition = videoTransition()
        transition.type = .fadeIn
        transition.duration = duration
        return transition
    }
    
    static func fadeOutTransitionWithDuration(duration: CMTime) -> THVideoTransition {
        let transition = videoTransition()
        transition.type = .fadeOut
        transition.duration = duration
        return transition
    }
    
    static func dissolveTransitionWithDuration(duration: CMTime) -> THVideoTransition {
        let transition = videoTransition()
        transition.type = .dissolve
        transition.duration = duration
        return transition
    }
    
    static func pushTransitionWithDuration(duration: CMTime, direction: THPushTransitionDirection) -> THVideoTransition {
        let transition = videoTransition()
        transition.type = .push
        transition.duration = duration
        transition.direction = direction
        return transition
    }
}
