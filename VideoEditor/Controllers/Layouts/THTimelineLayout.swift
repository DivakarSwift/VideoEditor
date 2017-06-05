//
//  THTimelineLayout.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

protocol UICollectionViewDelegateTimelineLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDeleteItemAt indexPath:IndexPath)
    func collectionView(_ collectionView: UICollectionView, didMoveMediaItemAt fromIndexPath: IndexPath, toIndexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, didAdjustToWidth width: CGFloat, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView:UICollectionView, didAdjustToPosition position: CGPoint, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, withForItemAt indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, positionForItemAt indexPath: IndexPath) -> CGPoint
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool
}

enum THPanDirection: Int {
    case left = 0
    case right = 1
}

enum THDragMode: Int {
    case none = 0
    case move = 1
    case trim = 2
}

class THTimelineLayout: UICollectionViewLayout {
    
    let DEFAULT_TRACK_HEIGHT: CGFloat = 80.0
    let DEFAULT_CLIP_SPACING: CGFloat = 0.0
    let TRANSITION_CONTROL_HW: CGFloat = 32.0
    let VERTICAL_PADDING: CGFloat = 4.0
    let DEFAULT_INSETS = UIEdgeInsetsMake(4.0, 5.0, 5.0, 5.0)
    
    fileprivate var trackHeight: CGFloat?
    fileprivate var clipSpacing: CGFloat?
    fileprivate var trackInsets: UIEdgeInsets?
    fileprivate var reorderingAllowed: Bool?
    
    var contentSize: CGSize?
    var calculatedLayout: Dictionary<IndexPath, THTimelineLayoutAttributes>?
    var initialLayout: Dictionary<AnyHashable, Any>?
    var updates: Array<Any>?
    var scaleUnit: CGFloat?
    var panDirection: THPanDirection?
    var panGesutreRecoginizer: UIPanGestureRecognizer?
    var longPressgestureRecognizer: UILongPressGestureRecognizer?
    var tapGesutreRecognizer: UITapGestureRecognizer?
    var selectedIndexpath: IndexPath?
    var draggableImageView: UIImageView?
    var swapInProgress: Bool? = false
    var dragMode: THDragMode?
    var trimming: Bool?
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setup() {
        trackInsets = DEFAULT_INSETS
        trackHeight = DEFAULT_TRACK_HEIGHT
        clipSpacing = DEFAULT_CLIP_SPACING
        reorderingAllowed = true
        dragMode = .trim
    }
    
    func setTrackHeight(trackHeight: CGFloat) {
        if self.trackHeight != trackHeight {
            self.trackHeight = trackHeight
            self.invalidateLayout()
        }
    }
    
    func setClipSpacing(clipSpacing: CGFloat) {
        if self.clipSpacing != clipSpacing {
            self.clipSpacing = clipSpacing
            self.invalidateLayout()
        }
    }
    func setTrackInsets(trackInsets: UIEdgeInsets) {
        if self.trackInsets != trackInsets {
            self.trackInsets = trackInsets
            self.invalidateLayout()
        }
    }
    
    func setReodrderingAllowed(reorderingAllowed: Bool) {
        if self.reorderingAllowed != reorderingAllowed {
            self.reorderingAllowed = reorderingAllowed
            self.panGesutreRecoginizer?.isEnabled = reorderingAllowed
            self.longPressgestureRecognizer?.isEnabled = reorderingAllowed
            self.invalidateLayout()
        }
    }
}

extension THTimelineLayout {
    override func prepare() {
        var layoutDictionary = Dictionary<IndexPath, THTimelineLayoutAttributes>()
        var xPos = self.trackInsets?.left
        var yPos:CGFloat = 0.0
        var maxTrackWidth:CGFloat = 0.0
        let delegate = self.collectionView?.delegate as? UICollectionViewDelegateTimelineLayout
        let trackCount = self.collectionView?.numberOfSections
        for track in 0..<trackCount! {
            let itemCount = self.collectionView?.numberOfItems(inSection: track)
            for item in 0..<itemCount! {
                let indexPath = IndexPath(item: item, section: track)
                let attributes = THTimelineLayoutAttributes(forCellWith: indexPath)
                let width = delegate?.collectionView(self.collectionView!, withForItemAt: indexPath)
                let position: CGPoint = (delegate?.collectionView(self.collectionView!, positionForItemAt: indexPath))!
                
                if position.x > 0.0 {
                    xPos = position.x
                }
                
                attributes.frame = CGRect(x: xPos!, y: yPos + (self.trackInsets?.top)!, width: width!, height: self.trackHeight! - (self.trackInsets?.bottom)!)
                
                if width == TRANSITION_CONTROL_HW {
                    var rect = attributes.frame
                    rect.origin.y = (rect.origin.y) + (((rect.size.height) - TRANSITION_CONTROL_HW) / 2) + VERTICAL_PADDING
                    rect.origin.x = (rect.origin.x) - (TRANSITION_CONTROL_HW / 2)
                    attributes.frame = rect
                    attributes.zIndex = 1
                }
                
                if self.selectedIndexpath != nil && (self.selectedIndexpath?.elementsEqual(indexPath))! {
                    attributes.isHidden = true
                }
                
                layoutDictionary[indexPath] = attributes
                
                if width != TRANSITION_CONTROL_HW
                {
                    xPos = xPos! + (width! + self.clipSpacing!)
                }
            }
            
            if xPos! > maxTrackWidth {
                maxTrackWidth = xPos!
            }
            xPos = self.trackInsets?.left
            yPos = yPos + self.trackHeight!
        }
        
        self.contentSize = CGSize(width: maxTrackWidth, height: self.trackHeight! * CGFloat(trackCount!))
        
        self.calculatedLayout = layoutDictionary
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return self.contentSize!
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributesInRect = [UICollectionViewLayoutAttributes]()
        if self.calculatedLayout != nil {
            for (_, attributes) in self.calculatedLayout! {
                if rect.intersects(attributes.frame) {
                    allAttributesInRect.append(attributes)
                }
            }
        }
        
        return allAttributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if self.calculatedLayout == nil {
            return nil
        }
        return self.calculatedLayout?[indexPath]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(recognizer:)))
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longPressRecognizer.minimumPressDuration = 0.5
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        
        for recognizer in (self.collectionView?.gestureRecognizers)! {
            if recognizer is UIPanGestureRecognizer {
                recognizer.require(toFail: panRecognizer)
            }
            else if recognizer is UILongPressGestureRecognizer {
                recognizer.require(toFail: longPressRecognizer)
            }
        }
        
        self.panGesutreRecoginizer = panRecognizer
        self.longPressgestureRecognizer = longPressRecognizer
        self.tapGesutreRecognizer = tapRecognizer
        
        self.panGesutreRecoginizer?.delegate = self
        self.longPressgestureRecognizer?.delegate = self
        self.tapGesutreRecognizer?.delegate = self
        
        self.collectionView?.addGestureRecognizer(panRecognizer)
        self.collectionView?.addGestureRecognizer(longPressRecognizer)
        self.collectionView?.addGestureRecognizer(tapRecognizer)
    }
}

extension THTimelineLayout: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// Gesture Handler
extension THTimelineLayout {
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: location)
        let delegate = self.collectionView?.delegate as? UICollectionViewDelegateTimelineLayout
        delegate?.collectionView(self.collectionView!, willDeleteItemAt: indexPath!)
        self.collectionView?.deleteItems(at: [indexPath!])
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.began {
            self.dragMode = .move
            let location = recognizer.location(in: self.collectionView)
            let indexPath = self.collectionView?.indexPathForItem(at: location)
            
            if indexPath == nil {
                return
            }
            
            self.selectedIndexpath = indexPath
            self.collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition(rawValue: 0))
            let cell = self.collectionView?.cellForItem(at: indexPath!)
            cell?.isHighlighted = true
            
            self.draggableImageView = cell?.toImageView()
            self.draggableImageView?.frame = (cell?.frame)!
            
            self.collectionView?.addSubview(self.draggableImageView!)
        }
        
        if recognizer.state == UIGestureRecognizerState.ended {
            let attributes = self.layoutAttributesForItem(at: self.selectedIndexpath!)
            UIView.animate(withDuration: 0.15, animations: { 
                self.draggableImageView?.frame = (attributes?.frame)!
            }, completion: { (finished) in
                self.invalidateLayout()
                UIView.animate(withDuration: 0.2, animations: { 
                    self.draggableImageView?.alpha = 0.0
                }, completion: { (complete) in
                    let cell = self.collectionView?.cellForItem(at: self.selectedIndexpath!)
                    cell?.isSelected = true
                    self.draggableImageView?.removeFromSuperview()
                    self.draggableImageView = nil
                })
                
                self.selectedIndexpath = nil
                self.dragMode = .trim
            })
        }
    }
    
    func handleDrag(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self.collectionView)
        let translation = recognizer.translation(in: self.collectionView)
        self.panDirection = translation.x > 0 ? .right: .left
        let indexPath = self.collectionView?.indexPathForItem(at: location)

        if recognizer.state == .began {
            self.invalidateLayout()
        }
        
        if recognizer.state == .began || recognizer.state == .changed {
            if self.dragMode == .move {
                let centerPoint = self.draggableImageView?.center
                self.draggableImageView?.center = CGPoint(x: (centerPoint?.x)! + translation.x, y: (centerPoint?.y)! + translation.y)
                if self.selectedIndexpath?.section == 0 {
                    if !self.swapInProgress! {
                        self.swapClips()
                    }
                }
                else {
                    let xOrigin = (self.draggableImageView?.center.x)! - (self.draggableImageView?.frameWidth())! / 2
                    let delegate = self.collectionView?.delegate as? UICollectionViewDelegateTimelineLayout
                    let originPoint = CGPoint(x: xOrigin, y: 0.0)
                    delegate?.collectionView(self.collectionView!, didAdjustToPosition: originPoint, forItemAt: self.selectedIndexpath!)
                }
            }
            else {
                if indexPath == nil || indexPath?.section != 0 {
                    return
                }
                var cell = self.collectionView?.cellForItem(at: indexPath!) as? THVideoItemCollectionViewCell
                let timeRange = cell?.maxTimeRange
                self.scaleUnit = CGFloat(CMTimeGetSeconds((timeRange?.duration)!)) / (cell?.frameWidth())!
                let selectedPaths = self.collectionView?.indexPathsForSelectedItems
                if selectedPaths != nil && (selectedPaths?.count)! > 0 {
                    if let selectedPath = selectedPaths?[0] {
                        cell = self.collectionView?.cellForItem(at: selectedPath) as? THVideoItemCollectionViewCell
                        if cell != nil {
                            if (cell?.isPointInDragHandle(point: (self.collectionView?.convert(location, to: cell))!))! {
                                self.trimming = true
                            }
                            if self.trimming! {
                                let newFrameWidth = (cell?.frameWidth())! + translation.x
                                self.adjustedToWidth(width: newFrameWidth)
                            }
                        }
                        
                    }
                }
            }
            
            recognizer.setTranslation(CGPoint.zero, in: self.collectionView)
        }
        else if recognizer.state == .ended || recognizer.state == .cancelled {
            self.trimming = false
        }
    }
    
    func shouldSwapSelectedIndexPath(selected: IndexPath, withIndexPath hovered: IndexPath) -> Bool {
        if self.panDirection == .right {
            return selected.row < hovered.row
        }
        else {
            return selected.row > hovered.row
        }
    }
    
    func swapClips() {
        let hoverIndexPath = self.collectionView?.indexPathForItem(at: (self.draggableImageView?.center)!)
        let delegate = self.collectionView?.delegate as? UICollectionViewDelegateTimelineLayout
        
        if hoverIndexPath != nil && self.shouldSwapSelectedIndexPath(selected: self.selectedIndexpath!, withIndexPath: hoverIndexPath!) {
            if !(delegate?.collectionView(self.collectionView!, canMoveItemAt: hoverIndexPath!))! {
                return
            }
            
            self.swapInProgress = true
            let lastSelectedIndexpath = self.selectedIndexpath
            self.selectedIndexpath = hoverIndexPath
            delegate?.collectionView(self.collectionView!, didMoveMediaItemAt: lastSelectedIndexpath!, toIndexPath: self.selectedIndexpath!)
            
            self.collectionView?.performBatchUpdates({ 
                self.collectionView?.deleteItems(at: [lastSelectedIndexpath!])
            }, completion: { (finished) in
                self.swapInProgress = false
                self.invalidateLayout()
            })
        }
    }
}

// Event Handler Methods

extension THTimelineLayout {
    func adjustedToWidth(width: CGFloat) {
        let delegate = self.collectionView?.delegate as? UICollectionViewDelegateTimelineLayout
        let indexPath = self.collectionView?.indexPathsForSelectedItems?[0]
        delegate?.collectionView(self.collectionView!, didAdjustToWidth: width, forItemAt: indexPath!)
        self.invalidateLayout()
    }
}

