//
//  THVideoTransitionDurationViewModel.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

class THVideoTransitionDurationViewModel: NSObject {
    var title: String?
    var duration: CMTime?
    
    static func durationViewModel(withTitle durationTitle: String, duration: CMTime) -> THVideoTransitionDurationViewModel {
        let model = THVideoTransitionDurationViewModel()
        model.title = durationTitle
        model.duration = duration
        return model
    }
}
