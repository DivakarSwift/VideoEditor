//
//  THTableSectionHeaderView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTableSectionHeaderView: UIView {

    var label: UILabel?
    
//    var title: String {
//        get {
//            return self.title
//        }
//        set(title) {
//            self.title = title
//            label?.text = title
//        }
//    }
    
    func setTitle(title: String) {
        label?.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.298, alpha: 1.000)
        var labelFrame = frame
        labelFrame.origin.x = 10.0
        label = UILabel(frame: labelFrame)
        label?.backgroundColor = UIColor.clear
        label?.textColor = UIColor.white
        label?.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(label!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
