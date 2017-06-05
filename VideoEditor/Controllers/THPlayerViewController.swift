//
//  THPlayerViewController.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import AVFoundation

var PlayerItemStatusContext: String?

class THPlayerViewController: UIViewController {
    
    let STATUS_KEYPATH = "status"
    let VIDEO_SIZE = CGSize(width: 1280, height: 720)
    
    var asset: AVAsset?
    @IBOutlet weak var playbackView: THPlaybackView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var exportProgressView: THExportProgressView!
    
    var playbackMediator: THPlaybackMediator?
    var exporting: Bool?
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var srubbing: Bool?
    var lastPlaybackRate: Float?
    var autoplayContent: Bool?
    var readyForDisplay: Bool? = false
    var titleView: UIView?
    var settingsPopover: UIPopoverPresentationController?
    var mutingAudioMix: AVAudioMix?
    var lastAudioMix: AVAudioMix?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.autoplayContent = true
        self.player = AVPlayer(playerItem: nil)
        self.playbackView.player = self.player!
        self.view.bringSubview(toFront: self.loadingView)
    }
    
    func loadInitialPlayerItem(playerItem: AVPlayerItem) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.autoplayContent = false
                self.playPlayerItem(playerItem: playerItem)
//                self.prepareToPlay()
            }
        }
    }
    
    func playPlayerItem(playerItem: AVPlayerItem) {
        self.titleView?.removeFromSuperview()
        self.autoplayContent = true
        self.player?.rate = 0.0
        self.playerItem = playerItem
        self.playButton.isSelected = true
//        if playerItem != nil {
            self.prepareToPlay()
//        }
//        else {
//            print("Player item is nil. Nothing to play.")
//        }
    }
    
    func prepareToPlay() {
        if self.playerItem == nil {
            return
        }
        self.player?.replaceCurrentItem(with: self.playerItem)
        self.playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &PlayerItemStatusContext)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        
        if self.playerItem?.titleLayer != nil {
            self.addSynchronizedLayer(synchLayer: (self.playerItem?.titleLayer)!)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &PlayerItemStatusContext {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    if self.autoplayContent! {
                        self.player?.play()
                    }
                    else {
                        self.stopPlayback()
                    }
                    
                    self.playerItem?.removeObserver(self, forKeyPath: self.STATUS_KEYPATH)
                    self.prepareAudioMixes()
                    
                    if !self.readyForDisplay! {
                        UIView.animate(withDuration: 0.35, animations: { 
                            self.loadingView.alpha = 0.0
                        }, completion: { (complete) in
                            self.view.sendSubview(toBack: self.loadingView)
                        })
                    }
                }
            }
        }
    }
    
    // Actions
    @IBAction func play(_ sender: Any?) {
        let button = sender as? UIButton
        if self.player?.rate == 1.0 {
            self.player?.rate = 0.0
            button?.isSelected = false
        }
        else {
            self.playbackMediator?.prepareTimelineForPlayback()
            button?.isSelected = true
        }
    }
    
    @IBAction func beginRewinding(_ sender: Any?) {
        self.lastAudioMix = self.playerItem?.audioMix
        self.lastPlaybackRate = (self.player?.rate)!
        self.playerItem?.audioMix = self.mutingAudioMix
        self.player?.rate = -2.0
    }
    
    @IBAction func endRewinding(_ sender: Any?) {
        self.playerItem?.audioMix = self.lastAudioMix
        self.player?.rate = self.lastPlaybackRate!
    }
    
    @IBAction func beginFastForwarding(_ sender: Any?) {
        self.lastAudioMix = self.playerItem?.audioMix
        self.lastPlaybackRate = (self.player?.rate)!
        self.playerItem?.audioMix = self.mutingAudioMix
        self.player?.rate = 2.0
    }
    
    @IBAction func endFastForwarding(_ sender: Any?) {
        self.playerItem?.audioMix = self.lastAudioMix
        self.player?.rate = self.lastPlaybackRate!
    }
    
    func stopPlayback() {
        self.player?.rate = 0.0
        self.player?.seek(to: kCMTimeZero)
        self.playButton.isSelected = false
    }
}

extension THPlayerViewController {
    // Attach AVSynchronizedLayer to layer tree
    func addSynchronizedLayer(synchLayer: AVSynchronizedLayer) {
        self.titleView?.removeFromSuperview()
        self.titleView = UIView(frame: CGRect.zero)
        self.titleView?.layer.addSublayer(synchLayer)
        
        let scale:CGFloat = CGFloat(fminf(Float(self.view.boundsWidth() / VIDEO_SIZE.width), Float(self.view.boundsHeight() / VIDEO_SIZE.height)))
        let videoRect = AVMakeRect(aspectRatio: VIDEO_SIZE, insideRect: self.view.bounds)
        self.titleView?.center = CGPoint(x: videoRect.midX, y: videoRect.midY)
        self.titleView?.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    func playerItemDidReachEnd(notification: Notification) {
        self.stopPlayback()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: THPlaybackEndedNotification), object: nil)
    }

    // AVAudioMix Setup
    func prepareAudioMixes() {
        self.mutingAudioMix = self.buildAudioMix(forPlayerItem: self.playerItem!, level: 0.05)
        if self.playerItem?.audioMix == nil {
            self.playerItem?.audioMix = self.buildAudioMix(forPlayerItem: self.playerItem!, level: 1.0)
        }
    }
    
    func buildAudioMix(forPlayerItem playerItem: AVPlayerItem, level: CGFloat) -> AVAudioMix {
        var params = [AVMutableAudioMixInputParameters]()
        for track in playerItem.tracks {
            if track.assetTrack.mediaType == AVMediaTypeAudio {
                let parameters = AVMutableAudioMixInputParameters(track: track.assetTrack)
                parameters.setVolume(Float(level), at: kCMTimeZero)
                params.append(parameters)
            }
        }
        
        let audioMix = AVMutableAudioMix()
        audioMix.inputParameters = params
        return audioMix
    }
    
    // Display/Hide Export UI
    func setExporting(exporting: Bool) {
        if exporting {
            self.exportProgressView.progressView.setProgress(progress: 0.0)
            self.exportProgressView.alpha = 0.0
            self.view.bringSubview(toFront: self.exportProgressView)
            UIView.animate(withDuration: 0.4, animations: { 
                self.exportProgressView.alpha = 1.0
            })
        }
        else {
            UIView.animate(withDuration: 0.4, animations: { 
                self.exportProgressView.alpha = 0.0
            }, completion: { (complete) in
                self.view.bringSubview(toFront: self.exportProgressView)
            })
        }
    }
    
    // Settings Popover Segue Handling
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SettingsPopover" {
            if self.settingsPopover != nil {
                self.settingsPopover?.presentedViewController.dismiss(animated: true, completion: nil)
                return false
            }
        }
        return true;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsPopover" {
//            self.settingsPopover == (segue
        }
    }
}

