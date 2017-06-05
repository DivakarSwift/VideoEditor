//
//  THAudioPickerViewController.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

protocol THPlaybackMediator {
    func loadMediaItem(mdeiaItem: THMediaItem)
    func previewMediaItem(mediaItem: THMediaItem)
    func addMediaItem(item: THMediaItem, toTimeline track: THTrack)
    func prepareTimelineForPlayback()
    func stopPlayback()
}

class THAudioPickerViewController: UIViewController {
    
    let HEADER_HEIGHT:CGFloat = 34.0
    
    var playbackMediator: THPlaybackMediator?
    let THAudioItemCellID = "THAudioItemCell"
    
    var musicItems: [THAudioItem] = [THAudioItem]()
    func getMusicItems() -> [THAudioItem] {
        if self.musicItems.count == 0 {
            let urls = self.musicURLs
            var items = [THAudioItem]()
            for i in 0..<(urls!.count) {
                let url = urls![i]
                let item = THAudioItem.audioItem(withURL: url)
                item.prepare(nil)
                items.append(item)
            }
            self.musicItems += items
        }
        return self.musicItems
    }
    var voiceOverItems: [THAudioItem] = [THAudioItem]()
    
    func getVoiceOverItems() -> [THAudioItem] {
        if self.voiceOverItems.count == 0 {
            let urls = self.voiceOverURLs
            var items = [THAudioItem]()
            for i in 0..<(urls!.count) {
                let url = urls![i]
                let item = THAudioItem.audioItem(withURL: url)
                item.prepare(nil)
                items.append(item)
            }
            self.voiceOverItems += items
        }
        return self.voiceOverItems
    }
    var allAudioItems: [[THAudioItem]]?
    var previewCompleted: Bool? = false
    
    @IBOutlet var tableView: UITableView!
    
    var musicURLs: [URL]? {
        return Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: nil)
    }
    var voiceOverURLs: [URL]? {
        return Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.allAudioItems = [self.getMusicItems(), self.getVoiceOverItems()]
        
        NotificationCenter.default.addObserver(self, selector: #selector(previewComplete(notification:)), name: NSNotification.Name(rawValue: THPlaybackEndedNotification), object: nil)
//        self.tableView.register(THAudioItemTableViewCell.self, forCellReuseIdentifier: THAudioItemCellID)
        self.previewCompleted = false
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func previewComplete(notification: Notification) {
        self.previewCompleted = true
        self.tableView.reloadData()
    }

}

// TableView DataSource
extension THAudioPickerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.musicItems.count : self.voiceOverItems.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Music" : "Voice Overs"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: THAudioItemCellID, for: indexPath) as? THAudioItemTableViewCell
        self.registerCellActions(cell: cell!)
        let item = self.allAudioItems![indexPath.section][indexPath.row]
        if let titleLabel = cell?.titleLabel {
            titleLabel.text = item.getTitle()
        }
        if let button = cell?.previewButton {
            button.isSelected = false
        }
        return cell!
    }
 
    func registerCellActions(cell: THAudioItemTableViewCell) {
        if let button = cell.previewButton {
            button.addTarget(self, action: #selector(handlePreviewTap(_:)), for: .touchUpInside)
        }
        
        if let button = cell.addButton {
            button.addTarget(self, action: #selector(handleAddMediaItemTap(_:)), for: .touchUpInside)
        }
    }

    func handleAddMediaItemTap(_ sender: Any?) {
        let button = sender as? UIButton
        let indexPath = self.indexPathForButton(button: button!)
        let item = (indexPath.section == 0 ? self.musicItems[indexPath.row] : self.voiceOverItems[indexPath.row])
        self.playbackMediator?.addMediaItem(item: item, toTimeline: indexPath.section == 0 ? THTrack.music : THTrack.commentary)
    }
    
    func handlePreviewTap(_ sender: Any?) {
        let button = sender as? UIButton
        let indexPath = self.indexPathForButton(button: button!)
        if !(button?.isSelected)! {
            let item = (indexPath.section == 0 ? self.musicItems[indexPath.row] : self.voiceOverItems[indexPath.row])
            self.playbackMediator?.previewMediaItem(mediaItem: item)
        }
        else {
            self.playbackMediator?.stopPlayback()
        }
        button?.isSelected = !(button?.isSelected)!
    }
    
    func indexPathForButton(button: UIButton) -> IndexPath {
        let point = button.convert(button.bounds.origin, to: self.tableView)
        return self.tableView.indexPathForRow(at: point)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = THTableSectionHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frameWidth(), height: HEADER_HEIGHT))
        view.setTitle(title: self.tableView(tableView, titleForHeaderInSection: section)!)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
}

// TableView Delegate
extension THAudioPickerViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = self.allAudioItems![indexPath.section][indexPath.row] as? THAudioItem
//        let track = (indexPath.section == 0 ? THTrack.music:THTrack.commentary) as THTrack
//        self.playbackMediator?.addMediaItem(item: item!, toTimeline: track)
    }
    
    
}
