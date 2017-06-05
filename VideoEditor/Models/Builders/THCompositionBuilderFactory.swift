//
//  THCompositionBuilderFactory.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import AVFoundation

protocol THComposition {
    func makePlayable() -> AVPlayerItem
    func makeExportable() -> AVAssetExportSession
}
protocol THCompositionBuilder {
    func buildComposition() -> THComposition
}

class THCompositionBuilderFactory: NSObject {
    func builderForTimeline(timeline: THTimeline) -> THCompositionBuilder {
        if timeline.isSimpleTileLine() {
            return THBasicCompositionBuilder(withTimeline: timeline)
        }
        else {
            return THAdvancedCompositionBuilder(withTimeline: timeline)
        }
    }
}
