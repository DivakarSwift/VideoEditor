//
//  THVideoPickerViewController.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THVideoPickerViewController: UIViewController {
    
    let THVideoItemRowHeight: CGFloat = 64.0
    let THVideoItemCellID = "THVideoItemCell"
    
    var playbackMediator: THPlaybackMediator?
    var initialItemLoaded: Bool?
    
    fileprivate var videoURLs: [URL]? {
        var urls = [URL]();
        
        urls += (Bundle.main.urls(forResourcesWithExtension: "mov", subdirectory: nil)!)
        urls += (Bundle.main.urls(forResourcesWithExtension: "mp4", subdirectory: nil)!)
        return urls;
    }
    fileprivate var videoItems: [THVideoItem]?
    @IBOutlet var tableView: UITableView!
    
    func getVideoItems() -> [THVideoItem] {
        if self.videoItems == nil {
            var items = [THVideoItem]()
            let urls = self.videoURLs
            for i in 0..<(urls?.count)! {
                let url = urls?[i]
                let item = THVideoItem(withURL: url!)
                item.prepare({ (complete) in
                    if complete {
                        DispatchQueue.global().async {
                            DispatchQueue.main.async {
                                if i == 0 && !self.initialItemLoaded! {
                                    self.playbackMediator?.loadMediaItem(mdeiaItem: item)
                                    self.initialItemLoaded = true
                                }
                                let reloadPath = IndexPath(row: i, section: 0)
                                self.tableView.reloadRows(at: [reloadPath], with: .automatic)
                            }
                        }
                    }
                    else {
                        
                    }
                })
                items.append(item)
            }
            self.videoItems = items
        }
        return self.videoItems!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialItemLoaded = false
        self.tableView.register(THVideoItemTableViewCell.self, forCellReuseIdentifier: THVideoItemCellID)
        self.tableView.backgroundColor = UIColor(white: 0.206, alpha: 1.000)
        self.tableView.separatorStyle = .none
    }
}

extension THVideoPickerViewController: UITableViewDataSource {
    // UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getVideoItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: THVideoItemCellID, for: indexPath) as? THVideoItemTableViewCell
        self.registerCellActions(cell!)
        
        let item = self.videoItems![indexPath.row]
        cell?.setThumbnails(thumbnails: item.thumbnails!)
        return cell!
    }
    
    func registerCellActions(_ cell: THVideoItemTableViewCell) {
        cell.playButton.addTarget(self, action: #selector(handlePreviewTap(_:)), for: .touchUpInside)
        cell.addbutton.addTarget(self, action: #selector(handleAddMediaItemTap(_:)), for: .touchUpInside)
    }
    
    func handlePreviewTap(_ sender: Any?) {
        let button = sender as? UIButton
        let indexPath = self.indexPathForButton(button)
        if !(button?.isSelected)! {
            let item = self.videoItems![indexPath.row]
            self.playbackMediator?.previewMediaItem(mediaItem: item)
        }
        else {
            self.playbackMediator?.stopPlayback()
        }
        button?.isSelected = !(button?.isSelected)!
    }
    func handleAddMediaItemTap(_ sender: Any?) {
        let indexPath = self.indexPathForButton(sender as? UIButton)
        let item = self.videoItems?[indexPath.row]
        self.playbackMediator?.addMediaItem(item: item!, toTimeline: THTrack.video)
    }
    
    func indexPathForButton(_ button: UIButton?) -> IndexPath {
        let point = button?.convert((button?.bounds.origin)!, to: self.tableView)
        return self.tableView.indexPathForRow(at: point!)!
    }
}
extension THVideoPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return THVideoItemRowHeight
    }
    
    // UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
