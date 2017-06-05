//
//  THCompositionLayer.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

class THCompositionLayer: THTimelineItem {
    var identifier: String?
    
    func layer() -> CALayer? {
        assert(false, "Must be oerridden by subclass.")
        return nil
    }
}
