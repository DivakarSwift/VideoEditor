//
//  THMainViewController.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class THMainViewController: UIViewController {
    
    let SGUE_ADD_MEDIA_PICKER = "addMediaPickerViewController"
    let SEGUE_ADD_PLAYER = "addPlayerViewController"
    let SEGUE_ADD_TIMELINE = "addTimelineViewContrller"
    
    var timelineViewController: THTimelineViewController?
    var playerViewController: THPlayerViewController?
    var videoPickerViewController: THVideoPickerViewController?
    var audioPickerViewController: THAudioPickerViewController?
    
    var factory: THCompositionBuilderFactory?
    var exportSession: AVAssetExportSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(exportComposition(notification:)), name: NSNotification.Name(rawValue: THExportRequestedNotification), object: nil)
        
        AppDelegate.sharedDelegate().prepareMainViewController()
        self.factory = THCompositionBuilderFactory()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func exportComposition(notification: Notification) {
        let timeline = self.timelineViewController?.currentTimeline()
        let builder = self.factory?.builderForTimeline(timeline: timeline!)
        let composition = builder?.buildComposition()
        
        self.exportSession = composition?.makeExportable()
        self.exportSession?.outputURL = self.exportURL()
        self.exportSession?.outputFileType = AVFileTypeMPEG4
        
        self.exportSession?.exportAsynchronously(completionHandler: { 
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.writeExportedVideoToPhotosLibrary()
                }
            }
        })
        self.playerViewController?.exporting = true
        self.monitorExportProgress()
    }

    func monitorExportProgress() {
        let delayInSeconds = 0.1
        let popTime = DispatchTime(uptimeNanoseconds: UInt64(delayInSeconds) * NSEC_PER_SEC)
        DispatchQueue.global().asyncAfter(deadline: popTime) {
            DispatchQueue.main.async {
                let status = self.exportSession?.status
                if status == AVAssetExportSessionStatus.exporting {
                    let progressView = self.playerViewController?.exportProgressView.progressView
                    progressView?.setProgress(progress: (self.exportSession?.progress)!)
                    self.monitorExportProgress()
                }
                else if status == AVAssetExportSessionStatus.failed {
                    print("Failed")
                }
                else if status == AVAssetExportSessionStatus.completed {
                    self.playerViewController?.exporting = false
                }
            }
        }
    }
    
    func writeExportedVideoToPhotosLibrary() {
        let exportURL = self.exportSession?.outputURL
        PHPhotoLibrary.shared().performChanges({ 
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportURL!)
        }) { (success, error) in
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    if error != nil {
                        let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func exportURL() -> URL {
        var filePath = ""
        var count = 0
        
        repeat {
            filePath = NSTemporaryDirectory()
            let numberString = count > 0 ? "-\(count)":""
            filePath = filePath.appending("/Masterpiece-\(numberString).m4v")
            count = count + 1
        } while(FileManager.default.fileExists(atPath: filePath))
        return URL(fileURLWithPath: filePath)
    }
}

extension THMainViewController: THPlaybackMediator {
    func loadMediaItem(mdeiaItem: THMediaItem) {
        self.playerViewController?.loadInitialPlayerItem(playerItem: mdeiaItem.makePlayable())
    }
    
    func previewMediaItem(mediaItem: THMediaItem) {
        self.playerViewController?.playPlayerItem(playerItem: mediaItem.makePlayable())
    }
    
    func prepareTimelineForPlayback() {
        let timeline = self.timelineViewController?.currentTimeline()
        let builder = self.factory?.builderForTimeline(timeline: timeline!)
        let composition = builder?.buildComposition()
        self.playerViewController?.playPlayerItem(playerItem: (composition?.makePlayable())!)
    }
    
    func addMediaItem(item: THMediaItem, toTimeline track: THTrack) {
        self.timelineViewController?.addTimelineItems(item, toTrack: track)
    }
    
    func stopPlayback() {
        self.playerViewController?.stopPlayback()
    }
}
