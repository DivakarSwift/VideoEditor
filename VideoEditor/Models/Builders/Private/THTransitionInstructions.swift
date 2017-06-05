//
//  THTransitionInstructions.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import AVFoundation

class THTransitionInstructions: NSObject {
    var compositionInstruction: AVMutableVideoCompositionInstruction?
    var fromLayerInstruction: AVMutableVideoCompositionLayerInstruction?
    var toLayerInstruction: AVMutableVideoCompositionLayerInstruction?
    var transition: THVideoTransition?
}
