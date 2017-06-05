//
//  THTimelineViewController.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

class THTimelineViewController: UIViewController {
    
    var transitionsEnabled: Bool?
    var volumeFadesEnabled: Bool?
    var duckingEnabled: Bool?
    var titlesEnabled: Bool?
    
    var cellIDS: [String]?
    var dataSource: THTimelineDataSource?
    var transitionPopoverController: UIPopoverPresentationController?
    
    @IBOutlet weak var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

//        THAppSettings.sharedSettings.transitionsEnabled = true
        THAppSettings.sharedSettings.volumenFadesEnabled = true
        THAppSettings.sharedSettings.volumeDuckingEnabled = true
//        THAppSettings.sharedSettings.titlesEnabled = true
        
        self.transitionsEnabled = THAppSettings.sharedSettings.transitionsEnabled
        self.volumeFadesEnabled = THAppSettings.sharedSettings.volumenFadesEnabled
        self.duckingEnabled = THAppSettings.sharedSettings.volumeDuckingEnabled
        self.titlesEnabled = THAppSettings.sharedSettings.titlesEnabled
        
        self.registerForNotifications()
        
        self.dataSource = THTimelineDataSource(withController: self)
        self.collectionView?.delegate = self.dataSource
        self.collectionView?.dataSource = self.dataSource
        
        let backgroundView = UIView(frame: CGRect.zero)
        let patternImage = #imageLiteral(resourceName: "app_black_background")
        let insetRect = CGRect(x: 2.0, y: 2.0, width: patternImage.size.width, height: patternImage.size.height)
        let image = patternImage.cgImage?.cropping(to: insetRect)
        backgroundView.backgroundColor = UIColor(patternImage: UIImage(cgImage: image!))
        self.collectionView?.backgroundView = backgroundView
    }

    // Register Notification Handlers
    func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(toggleTransitionsEnabledState(_:)), name: NSNotification.Name(rawValue: THTransitionsEnabledStateChangeNotification), object: nil)
        notificationCenter.addObserver(self, selector: #selector(toggleVolumeFadesEnabledState(_:)), name: NSNotification.Name(rawValue: THVolumeFadesEnabledStateChangeNotification), object: nil)
        notificationCenter.addObserver(self, selector: #selector(toggleVolumeDuckingEnabledState(_:)), name: NSNotification.Name(rawValue: THVolumeDuckingEnabledStateChangeNotification), object: nil)
        notificationCenter.addObserver(self, selector: #selector(toggleShowTitlesEnabledState(_:)), name: NSNotification.Name(rawValue: THShowTitlesEnabledStateChangeNotification), object: nil)
    }
    
    // Notification Handlers
    func toggleTransitionsEnabledState(_ notification: Notification) {
        let state = notification.object as? Bool
        if self.transitionsEnabled != state {
            self.transitionsEnabled = state
            let layout = self.collectionView?.collectionViewLayout as? THTimelineLayout
            layout?.setReodrderingAllowed(reorderingAllowed: !state!)
            self.collectionView?.reloadData()
        }
    }

    func toggleVolumeFadesEnabledState(_ notification: Notification) {
        self.volumeFadesEnabled = notification.object as? Bool
        let items = self.dataSource?.timelineItems![THTrack.music.rawValue]
        if items != nil && items!.count > 0 {
            let model = items?.last as? THTimelineItemViewModel
            let item = model?.timelineItem as? THAudioItem
            item?.volumeAutomation = self.volumeFadesEnabled! ? self.buildVolumeFades(forMusic: item!) : nil
        }
        self.collectionView?.reloadData()
    }
    
    func toggleVolumeDuckingEnabledState(_ notification: Notification) {
        self.duckingEnabled = notification.object as? Bool
        self.collectionView?.reloadData()
    }
    
    func toggleShowTitlesEnabledState(_ notification: Notification) {
        self.titlesEnabled = notification.object as? Bool
        if self.titlesEnabled! {
            let tapHarmonicLayer = THTitleLayer()
            tapHarmonicLayer.identifier = "TapHarmonic Layer"
            tapHarmonicLayer.titleText = "TapHarmonic Films Presents"
            tapHarmonicLayer.titleImage = #imageLiteral(resourceName: "tapharmonic_logo")
            tapHarmonicLayer.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(3, 1))
            tapHarmonicLayer.startTimeInTimeLine = CMTimeMake(1, 1)
            
            let renioLayer = THTitleLayer()
            renioLayer.identifier = "AV Foundation Layer"
            renioLayer.titleText = "Renaissance: Master Video"
            renioLayer.titleImage = #imageLiteral(resourceName: "renio")
            renioLayer.useLargeFont = true
            renioLayer.spinOut = true
            renioLayer.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(4, 1))
            renioLayer.startTimeInTimeLine = CMTimeMake(55, 10)
            
            let tapHarmonicModel = THTimelineItemViewModel(withTimelineItem: tapHarmonicLayer)
            tapHarmonicModel.positionInTimeline = tapHarmonicModel.THGetOriginForTime(time: tapHarmonicLayer.startTimeInTimeLine)
            let avFoundationModel = THTimelineItemViewModel(withTimelineItem: renioLayer)
            avFoundationModel.positionInTimeline = avFoundationModel.THGetOriginForTime(time: renioLayer.startTimeInTimeLine)
            
            var items = self.dataSource?.timelineItems![THTrack.title.rawValue]
            items?.append(tapHarmonicModel)
            items?.append(avFoundationModel)
        }
        else {
            var items = self.dataSource?.timelineItems![THTrack.title.rawValue]
            items?.removeAll()
        }
        
        self.collectionView?.reloadData()
    }
    
    // Build Model States
    
    func buildVolumeFades(forMusic item: THAudioItem) -> Array<THVolumeAutomation> {
        let fadeTime = CMTimeMake(3, 1)
        var automation = Array<THVolumeAutomation>()
        let startRange = CMTimeRangeMake(kCMTimeZero, fadeTime)
        automation.append(THVolumeAutomation.volumeAutomation(withTimeRange: startRange, startVolume: 0.0, endVolume: 1.0))
        
        let voiceOvers = self.dataSource?.timelineItems![THTrack.commentary.rawValue] as? [THTimelineItemViewModel]
        for model in voiceOvers! {
            let mediaItem = model.timelineItem
            let timerange = mediaItem?.timeRange
            let halfSecond = CMTimeMake(1, 2)
            let startTime = CMTimeSubtract((mediaItem?.startTimeInTimeLine)!, halfSecond)
            let endRangeStartTime = CMTimeAdd((mediaItem?.startTimeInTimeLine)!, (timerange?.duration)!)
            let endRange = CMTimeRangeMake(endRangeStartTime, halfSecond)
            
            automation.append(THVolumeAutomation.volumeAutomation(withTimeRange: CMTimeRangeMake(startTime, halfSecond), startVolume: 1.0, endVolume: 0.2))
            automation.append(THVolumeAutomation.volumeAutomation(withTimeRange: endRange, startVolume: 1.0, endVolume: 0.0))
        }
        
        let endRangeStartTime = CMTimeSubtract(item.timeRange.duration, fadeTime)
        let endRange = CMTimeRangeMake(endRangeStartTime, fadeTime)
        automation.append(THVolumeAutomation.volumeAutomation(withTimeRange: endRange, startVolume: 1.0, endVolume: 0.0))
        
        return automation
    }
    
    // Add Timeline Items
    func addTimelineItems(_ timelineItem: THTimelineItem, toTrack track: THTrack) {
        let model = THTimelineItemViewModel.model(withTimelineItem: timelineItem)
        var indexPaths = Array<IndexPath>()
        var items = self.dataSource?.timelineItems![track.rawValue]
        if track == THTrack.video && self.transitionsEnabled! && items != nil && (items?.count)! > 0 {
            let transition = THVideoTransition.dissolveTransitionWithDuration(duration: CMTimeMake(1, 2))
//            items?.append(transition)
            self.dataSource?.addTimelineItems(transition, toTrack: track)
            let path = IndexPath(item: (items?.count)! - 1, section: track.rawValue)
            indexPaths.append(path)
        }
        
        if track == THTrack.music && self.volumeFadesEnabled! {
            let audioItem = timelineItem as? THAudioItem
            audioItem?.volumeAutomation = self.buildVolumeFades(forMusic: audioItem!)
        }
        
//        items?.append(model)
        self.dataSource?.addTimelineItems(model, toTrack: track)
        
        items = self.dataSource?.timelineItems![track.rawValue]
        let path = IndexPath(item: (items?.count)! - 1, section: track.rawValue)
        indexPaths.append(path)
        
        self.collectionView?.insertItems(at: indexPaths)
//        self.collectionView?.reloadData()
    }
    
    // Get current THTimeline snapshot
    func currentTimeline() -> THTimeline {
        let timelineItems = self.dataSource?.timelineItems
        return THTimelineBuilder.buildTimeline(withMediaItems: timelineItems!)
    }
}
