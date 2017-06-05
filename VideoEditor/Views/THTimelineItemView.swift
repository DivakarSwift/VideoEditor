//
//  THTimelineItemView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTimelineItemView: UIView {

    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor(white: 1.0, alpha: 0.25).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor(white: 1.0, alpha: 0.25).cgColor
    }

    override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set (color) {
            super.backgroundColor = color
            self.setNeedsDisplay()
        }
    }
}
