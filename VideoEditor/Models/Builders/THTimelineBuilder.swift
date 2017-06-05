//
//  THTimelineBuilder.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

enum THTrack: Int {
    case video = 0
    case title = 1
    case commentary = 2
    case music = 3
}
class THTimelineBuilder: NSObject {
    static func buildTimeline(withMediaItems mediaItems: [[Any]]) -> THTimeline {
        let timeline = THTimeline()
        timeline.videos = self.buildVideoItems(viewModels: mediaItems[THTrack.video.rawValue])
        timeline.transitions = self.buildTransitions(viewModels: mediaItems[THTrack.video.rawValue])
        timeline.voiceOvers = self.buildMediaItems(adaptedItems: mediaItems[THTrack.commentary.rawValue]) as? Array<THMediaItem>
        timeline.musicItems = self.buildMediaItems(adaptedItems: mediaItems[THTrack.music.rawValue]) as? Array<THAudioItem>
        
        return timeline
    }
    
    static func buildMediaItems(adaptedItems: Array<Any>) -> Array<THTimelineItem> {
        var items = [THTimelineItem]()
        for adapter in adaptedItems as! [THTimelineItemViewModel] {
            adapter.updateTimelineItem()
            items.append(adapter.timelineItem!)
        }
        return items
    }
    
    static func buildTransitions(viewModels: Array<Any>) -> Array<THVideoTransition> {
        var items = [THVideoTransition]()
        for item in viewModels {
            if item is THVideoTransition {
                items.append(item as! THVideoTransition)
            }
        }
        return items
    }
    
    static func buildVideoItems(viewModels: Array<Any>) -> Array<THMediaItem> {
        var items = [THMediaItem]()
        for model in viewModels {
            if model is THTimelineItemViewModel && (model as! THTimelineItemViewModel).timelineItem is THMediaItem {
                (model as! THTimelineItemViewModel).updateTimelineItem()
                items.append((model as! THTimelineItemViewModel).timelineItem! as! THMediaItem)
            }
        }
        return items
    }
}
