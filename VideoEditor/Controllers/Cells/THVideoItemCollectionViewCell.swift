//
//  THVideoItemCollectionViewCell.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

class THVideoItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemView: THTimelineItemView!
    
    var maxTimeRange: CMTimeRange?
    var trimmerImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        if self.trimmerImageView != nil {
            return
        }
        let selectedImage = #imageLiteral(resourceName: "th_trimmer_ui_selected").stretchableImage(withLeftCapWidth: 17, topCapHeight: 0)
        let highlightedImage = #imageLiteral(resourceName: "th_trimmer_ui_highlighted").stretchableImage(withLeftCapWidth: 17, topCapHeight: 0)
        self.backgroundColor = UIColor.clear
        
        self.trimmerImageView = UIImageView(image: selectedImage, highlightedImage: highlightedImage)
        self.trimmerImageView?.layer.shadowColor = UIColor.black.cgColor
        self.trimmerImageView?.layer.shadowRadius = 3.0
        self.trimmerImageView?.layer.shadowOpacity = 0.5
        self.trimmerImageView?.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        self.trimmerImageView?.isUserInteractionEnabled = false
        self.trimmerImageView?.isHidden = true
        
        self.contentView.addSubview(self.trimmerImageView!)
    }
    
    func isPointInDragHandle(point: CGPoint) -> Bool {
        let handleRect = CGRect(x: self.frame.width - 30, y: 0, width: 30, height: self.frame.height)
        let contains = handleRect.contains(point)
        return contains
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set(selected) {
            super.isSelected = selected
            self.trimmerImageView?.frame = self.bounds
            self.trimmerImageView?.isHidden = !selected
            self.trimmerImageView?.isHighlighted = false
        }
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set (highlighted) {
            super.isHighlighted = highlighted
            self.trimmerImageView?.isHighlighted = highlighted
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.trimmerImageView?.frame = self.bounds
    }
}
