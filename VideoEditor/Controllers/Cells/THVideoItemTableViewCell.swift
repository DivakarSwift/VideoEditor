//
//  THVideoItemTableViewCell.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THVideoItemTableViewCell: UITableViewCell {
    
    weak var playButton:UIButton! {
        get {
            return self.overlayView?.playButton
        }
    }
    weak var addbutton: UIButton! {
        get {
            return self.overlayView?.addButton
        }
    }
    
    var overlayView: THVideoPickerOverlayView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundView = THThumbnailView(frame: self.bounds)
        self.contentView.backgroundColor = UIColor.clear
        self.overlayView = THVideoPickerOverlayView(frame: self.bounds)
        self.contentView.addSubview(self.overlayView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.overlayView?.isHidden = !selected
        if !selected {
            self.overlayView?.playButton?.isSelected = false
        }
    }
    
    func setThumbnails(thumbnails: Array<UIImage>) {
        (self.backgroundView as? THThumbnailView)?.setThumbnails(thumbnails: thumbnails)
    }
}
