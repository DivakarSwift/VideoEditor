//
//  THTimelineDataSource.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

class THTimelineDataSource: NSObject {
    
    let THVideoItemCollectionViewCellID = "THVideoItemCollectionViewCell"
    let THTransitionCollectionViewCellID = "THTransitionCollectionViewCell"
    let THTitleItemcollectionViewCellID = "THTitleItemCollectionViewCell"
    let THAudioItemCollectionviewCellID = "THAudioItemCollectionViewCell"
    
    var controller: THTimelineViewController?
    var transitionPopoverController: UIPopoverPresentationController?
    
    var timelineItems: [[Any]]? = [[Any](), [Any](), [Any](), [Any]()]
    
    static func dataSource(withController controller: THTimelineViewController) -> THTimelineDataSource {
        return THTimelineDataSource(withController: controller)
    }
    init(withController controller: THTimelineViewController) {
        super.init()
        self.controller = controller
//        self.timelineItems = items
    }
    
    func addTimelineItems(_ item: Any, toTrack track: THTrack) {
        self.timelineItems![track.rawValue] += [item]
    }
}

extension THTimelineDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.timelineItems?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timelineItems![section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = self.cellIDForIndexPath(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID!, for: indexPath)
        
        if cellID == THVideoItemCollectionViewCellID {
            self.configureVideoItemCell(cell: cell as! THVideoItemCollectionViewCell, withItemAtIndexpath: indexPath)
        }
        else if cellID == THAudioItemCollectionviewCellID {
            self.configureAudioItemCell(cell: cell as! THAudioItemCollectionViewCell, withItemAtIndexpath: indexPath)
        }
        else if cellID == THTransitionCollectionViewCellID {
            let transCell = cell as? THTransitionCollectionViewCell
            let transition = self.timelineItems?[indexPath.section][indexPath.row] as? THVideoTransition
            transCell?.button.setTransitionType(transitionType: (transition?.type)!)
        }
        else if cellID == THTitleItemcollectionViewCellID {
            self.configureTitleItemCell(cell: cell as! THTimelineItemCell, withItemAtIndexPath: indexPath)
        }
        return cell
    }
    
    func configureVideoItemCell(cell: THVideoItemCollectionViewCell, withItemAtIndexpath indexPath: IndexPath) {
        let model = self.timelineItems?[indexPath.section][indexPath.row] as? THTimelineItemViewModel
        let item = model?.timelineItem as? THVideoItem
        cell.maxTimeRange = item?.timeRange
        cell.itemView.label.text = item?.getTitle()
        cell.itemView.backgroundColor = UIColor(red: 0.523, green: 0.641, blue: 0.851, alpha: 1.000)
    }
    
    func configureAudioItemCell(cell: THAudioItemCollectionViewCell, withItemAtIndexpath indexPath: IndexPath) {
        let model = self.timelineItems?[indexPath.section][indexPath.row] as? THTimelineItemViewModel
        if indexPath.section == THTrack.music.rawValue {
            let item = model?.timelineItem as? THAudioItem
            cell.volumeAutomationView.setAudioRamps(audioRamps: (item?.volumeAutomation!)!)
            cell.volumeAutomationView.setDuration(duration: (item?.timeRange.duration)!)
            cell.itemView.backgroundColor = UIColor(red: 0.361, green: 0.724, blue: 0.366, alpha: 1.000)
        }
        else {
            cell.volumeAutomationView.setAudioRamps(audioRamps: nil)
            cell.volumeAutomationView.setDuration(duration: kCMTimeZero)
            cell.itemView.backgroundColor = UIColor(red: 0.992, green: 0.785, blue: 0.106, alpha: 1.000)
        }
    }
    
    func configureTitleItemCell(cell: THTimelineItemCell, withItemAtIndexPath indexPath: IndexPath) {
        let model = self.timelineItems![indexPath.section][indexPath.row] as? THTimelineItemViewModel
        let layer = model?.timelineItem as? THCompositionLayer
        cell.itemView.label.text = layer?.identifier
        cell.itemView.backgroundColor = UIColor(red: 0.741, green: 0.556, blue: 1.000, alpha: 1.000)
    }
    
    func cellIDForIndexPath(indexPath: IndexPath) -> String? {
        if (self.controller?.transitionsEnabled!)! && indexPath.section == 0 {
            return indexPath.item % 2 == 0 ? THVideoItemCollectionViewCellID : THTransitionCollectionViewCellID
        }
        else if indexPath.section == 0 {
            return THVideoItemCollectionViewCellID
        }
        else if indexPath.section == 1 {
            return THTitleItemcollectionViewCellID
        }
        else if indexPath.section == 2 {
            return THAudioItemCollectionviewCellID
        }
        return nil
    }
}

extension THTimelineDataSource: UICollectionViewDelegateTimelineLayout {
    
    @nonobjc func collectionView(_ collectionView: UICollectionView, willDeleteItemAt indexPath:IndexPath) {
        self.timelineItems![indexPath.section].remove(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 && !(self.controller?.transitionsEnabled)!
    }
    func collectionView(_ collectionView: UICollectionView, didMoveMediaItemAt fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        var items = self.timelineItems![fromIndexPath.section]
        if fromIndexPath.item == toIndexPath.item {
            print("FUBAR: Attempting to move: \(fromIndexPath.item) to \(toIndexPath.row)")
            assert(false, "Attempting to make invalid move.")
        }
        swap(&items[fromIndexPath.item], &items[toIndexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didAdjustToWidth width: CGFloat, forItemAt indexPath: IndexPath) {
        let model = self.timelineItems![indexPath.section][indexPath.row] as? THTimelineItemViewModel
        if width <= (model?.maxWidthInTimeline!)! {
            model?.widthInTimeline = width
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didAdjustToPosition position: CGPoint, forItemAt indexPath: IndexPath) {
        if indexPath.section == THTrack.commentary.rawValue || indexPath.section == THTrack.title.rawValue {
            let model = self.timelineItems![indexPath.section][indexPath.row] as? THTimelineItemViewModel
            model?.positionInTimeline = position
            model?.updateTimelineItem()
            self.controller?.collectionView?.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, withForItemAt indexPath: IndexPath) -> CGFloat {
        if (self.controller?.transitionsEnabled)! && indexPath.section == 0 && indexPath.item > 0 {
            if indexPath.item % 2 != 0 {
                return 32.0
            }
        }
        let model = self.timelineItems![indexPath.section][indexPath.row] as? THTimelineItemViewModel
        return (model?.getWidthInTimeline())!
    }
    
    func collectionView(_ collectionView: UICollectionView, positionForItemAt indexPath: IndexPath) -> CGPoint {
        if indexPath.section == THTrack.commentary.rawValue || indexPath.section == THTrack.title.rawValue {
            let model = self.timelineItems![indexPath.section][indexPath.row] as? THTimelineItemViewModel
            return (model?.positionInTimeline)!
        }
        return CGPoint.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = self.timelineItems![indexPath.section][indexPath.row]
        if selectedItem is THVideoTransition {
            self.configureTransition(transition: selectedItem as! THVideoTransition, atIndexPath: indexPath)
        }
    }
    
    func configureTransition(transition: THVideoTransition, atIndexPath indexPath: IndexPath) {
        let transitionController = THTransitionViewController.controllerWithTransition(transition: transition)
        transitionController.delegate = self
        self.transitionPopoverController = transitionController.popoverPresentationController
        self.transitionPopoverController?.permittedArrowDirections = UIPopoverArrowDirection.down
        let cell = self.controller?.collectionView?.cellForItem(at: indexPath)
        self.transitionPopoverController?.sourceRect = cell!.frame
        self.transitionPopoverController?.sourceView = self.controller?.view
        self.controller?.present(transitionController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, fromIndexPath: IndexPath, shouldMoveTo toIndexPath: IndexPath) -> Bool {
        return fromIndexPath.section == toIndexPath.section
    }
    
}

extension THTimelineDataSource: THTransitionViewControllerDelegate {
    func transitionSelected() {
        self.transitionPopoverController?.presentedViewController.dismiss(animated: true, completion: nil)
        self.transitionPopoverController = nil
        self.controller?.collectionView?.reloadData()
    }
}
