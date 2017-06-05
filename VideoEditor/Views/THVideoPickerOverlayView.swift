//
//  THVideoPickerOverlayView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THVideoPickerOverlayView: UIView {

    var playButton: UIButton?
    var pauseButton: UIButton?
    var addButton: UIButton?
    
    let BUTTON_WIDTH: CGFloat = 44.0
    let BUTTON_HEIGHT: CGFloat = 44.0
    let STOP_INSETS = UIEdgeInsetsMake(0, 0, 0, 0)
    let PLAY_INSETS = UIEdgeInsetsMake(0, 2, 0, 0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addButton = UIButton(type: .custom)
        self.playButton = UIButton(type: .custom)
        
        let bgImage = #imageLiteral(resourceName: "dark_button_background")
        self.addButton?.setBackgroundImage(bgImage, for: .normal)
        self.playButton?.setBackgroundImage(bgImage, for: .normal)
        self.addButton?.setImage(#imageLiteral(resourceName: "tp_add_media_icon"), for: .normal)
        self.playButton?.setImage(#imageLiteral(resourceName: "tp_play_icon"), for: .normal)
        self.playButton?.setImage(#imageLiteral(resourceName: "tp_stop_icon"), for: .selected)
        self.playButton?.imageEdgeInsets = PLAY_INSETS
        self.addSubview(self.addButton!)
        self.addSubview(self.playButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let yPos = (self.boundsHeight() - BUTTON_HEIGHT) / 2
        self.addButton?.frame = CGRect(x: self.bounds.midX - 10 - BUTTON_WIDTH, y: yPos, width: BUTTON_WIDTH, height: BUTTON_HEIGHT)
        self.playButton?.frame = CGRect(x: self.bounds.midX + 10, y: yPos, width: BUTTON_WIDTH, height: BUTTON_HEIGHT)
    }
}
