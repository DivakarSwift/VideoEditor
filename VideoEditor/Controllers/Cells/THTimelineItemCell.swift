//
//  THTimelineItemCell.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTimelineItemCell: UICollectionViewCell {
    @IBOutlet weak var itemView: THTimelineItemView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.backgroundColor = UIColor.clear
    }
}
