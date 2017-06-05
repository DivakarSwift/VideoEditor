//
//  THAdvancedCompositionBuilder.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

class THAdvancedCompositionBuilder: NSObject, THCompositionBuilder {
    let VIDEO_SIZE = CGSize(width: 1280, height: 720)
    let TITLE_LAYER_BOUNDS = CGRect(x: 0, y: 0, width: 1280, height: 720)
    let TRANSITION_DURATION = CMTimeMake(1, 1)
    
    var timeline: THTimeline?
    var composition: AVMutableComposition?
    var videoComposition: AVVideoComposition?
    var musicTrack: AVMutableCompositionTrack?
    
    init(withTimeline timeline: THTimeline) {
        super.init()
        self.timeline = timeline
    }
    
    func buildComposition() -> THComposition {
        self.composition = AVMutableComposition()
        self.buildCompositionTracks()
        return THAdvancedComposition(withComposition: self.composition!, videoComposition: self.buildVideoComposition(), audioMix: self.buildAudioMix()!, titleLayer: self.buildTitleLayer())
    }
    
    func buildCompositionTracks() {
        let compositionTrackA = self.composition?.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionTrackB = self.composition?.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        var tracks = [compositionTrackA, compositionTrackB]
        var cursorTime = kCMTimeZero
        
        let transitionDuration = (self.timeline?.transitions?.count)! > 0 ? TRANSITION_DURATION:kCMTimeZero
        let videoCount = self.timeline?.videos?.count
        for i in 0..<Int(videoCount!) {
            let trackIndex = i % 2
            let item = self.timeline?.videos?[i]
            let currentTrack = tracks[trackIndex]
            let assetTrack = item?.asset?.tracks(withMediaType: AVMediaTypeVideo)[0]
            try! currentTrack?.insertTimeRange((item?.timeRange)!, of: assetTrack!, at: cursorTime)
            
            cursorTime = CMTimeAdd(cursorTime, (item?.timeRange.duration)!)
            cursorTime = CMTimeSubtract(cursorTime, transitionDuration)
        }
        
        let _ = self.addCompositionTrackOfType(mediaType: AVMediaTypeAudio, mediaItems: (self.timeline?.voiceOvers)!)
        self.musicTrack = self.addCompositionTrackOfType(mediaType: AVMediaTypeAudio, mediaItems: (self.timeline?.musicItems)!)
    }
    
    func addCompositionTrackOfType(mediaType: String, mediaItems: Array<THMediaItem>) -> AVMutableCompositionTrack {
        var compositionTrack: AVMutableCompositionTrack? = nil
        if mediaItems.count > 0 {
            compositionTrack = self.composition?.addMutableTrack(withMediaType: mediaType, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            var cursorTime = kCMTimeZero
            
            for item in mediaItems {
                if item.startTimeInTimeLine != kCMTimeInvalid {
                    cursorTime = item.startTimeInTimeLine
                }
                
                let assetTrack = item.asset?.tracks(withMediaType: mediaType)[0]
                try! compositionTrack?.insertTimeRange(item.timeRange, of: assetTrack!, at: cursorTime)
                cursorTime = CMTimeAdd(cursorTime, item.timeRange.duration)
            }
        }
        
        return compositionTrack!
    }
    
    func buildVideoComposition() -> AVVideoComposition {
        let composition = AVMutableVideoComposition(propertiesOf: self.composition!)
        let transitionInstructions = self.transitionInstrunctionsInVideoComposition(videoComposition: composition)
        for instructions in transitionInstructions {
            let timeRange = instructions.compositionInstruction?.timeRange
            let fromLayerInstruction = instructions.fromLayerInstruction
            let toLayerInstruction = instructions.toLayerInstruction
            
            if instructions.transition?.type == THVideoTransitionType.dissolve {
                fromLayerInstruction?.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity: 0.0, timeRange: timeRange!)
            }
            else if instructions.transition?.type == THVideoTransitionType.push {
                fromLayerInstruction?.setTransformRamp(fromStart: CGAffineTransform.identity, toEnd: CGAffineTransform(translationX: -VIDEO_SIZE.width, y: 0.0), timeRange: timeRange!)
                
                toLayerInstruction?.setTransformRamp(fromStart: CGAffineTransform(translationX: VIDEO_SIZE.width, y: 0.0), toEnd: CGAffineTransform.identity, timeRange: timeRange!)
            }
            
            instructions.compositionInstruction?.layerInstructions = [fromLayerInstruction!, toLayerInstruction!]
        }
        return composition
    }
    
    func transitionInstrunctionsInVideoComposition(videoComposition: AVVideoComposition) -> Array<THTransitionInstructions> {
        var instructions = Array<THTransitionInstructions>()
        var layerInstructionIndex = 1
        for instruction in (videoComposition.instructions as? [AVMutableVideoCompositionInstruction])! {
            if instruction.layerInstructions.count == 2 {
                let transitionInstructions = THTransitionInstructions()
                transitionInstructions.compositionInstruction = instruction
                transitionInstructions.fromLayerInstruction = instruction.layerInstructions[1-layerInstructionIndex] as? AVMutableVideoCompositionLayerInstruction
                transitionInstructions.toLayerInstruction = instruction.layerInstructions[layerInstructionIndex] as? AVMutableVideoCompositionLayerInstruction
                instructions.append(transitionInstructions)
                
                layerInstructionIndex = layerInstructionIndex == 1 ? 0:1
            }
        }
        
        let transitions = self.timeline?.transitions
        if transitions == nil || transitions?.count == 0 {
            return instructions
        }
        
        assert(instructions.count == transitions?.count, "Instruction cound and transition count do not match.")
        
        for i in 0..<instructions.count {
            let transitionInstructions = instructions[i]
            transitionInstructions.transition = self.timeline?.transitions?[i]
        }
        return instructions
    }
    
    func buildAudioMix() -> AVAudioMix? {
        let items = self.timeline?.musicItems
        if items != nil && items?.count == 1 {
            let item = self.timeline?.musicItems?[0]
            
            let audioMix = AVMutableAudioMix()
            let parameters = AVMutableAudioMixInputParameters(track: self.musicTrack)
            for automation in (item?.volumeAutomation)! {
                parameters.setVolumeRamp(fromStartVolume: automation.startVolume!, toEndVolume: automation.endVolume!, timeRange: automation.timeRange!)
            }
            audioMix.inputParameters = [parameters]
            return audioMix
        }
        return nil
    }
    
    func buildTitleLayer() -> CALayer {
        let titleLayer = CALayer()
        titleLayer.bounds = CGRect(x: 0.0, y: 0.0, width: VIDEO_SIZE.width, height: VIDEO_SIZE.height)
        titleLayer.position = CGPoint(x: VIDEO_SIZE.width / 2, y: VIDEO_SIZE.height / 2)
        
        for compositionLayer in (self.timeline?.titles!)! {
            let layer = compositionLayer.layer()
            layer?.position = CGPoint(x: titleLayer.bounds.midX, y: titleLayer.bounds.midY)
            titleLayer.addSublayer(layer!)
        }
        return titleLayer
    }
}
