//
//  THTransitionButton.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTransitionButton: UIButton {

    fileprivate var transitionType: THVideoTransitionType?
    
    func setTransitionType(transitionType: THVideoTransitionType) {
        if self.transitionType == nil || self.transitionType != transitionType {
            self.transitionType = transitionType
            self.updateBackgroundImage()
        }
    }
    
    var typeToNameMapping: Dictionary<THVideoTransitionType, Any>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.setTransitionType(transitionType: THVideoTransitionType.none)
        self.typeToNameMapping = [THVideoTransitionType.none:#imageLiteral(resourceName: "trans_btn_bg_none"), THVideoTransitionType.dissolve: #imageLiteral(resourceName: "trans_btn_bg_xfade"), THVideoTransitionType.push: #imageLiteral(resourceName: "trans_btn_bg_push")]
        self.updateBackgroundImage()
    }
    
    func updateBackgroundImage() {
        let image = self.typeToNameMapping?[self.transitionType!]
        self.setBackgroundImage(image as? UIImage, for: UIControlState.normal)
    }
}
