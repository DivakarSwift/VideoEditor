//
//  THTabBarButton.swift
//  VideoEditor
//
//  Created by Mobdev125 on 6/1/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTabBarButton: UIButton {

    let IMG_FORMAT = "THTabBar"
    let IMG_FORMAT_SELECTED = "_selected"
    
    init(withImageName imageName:String) {
        super.init(frame: CGRect.zero)
        let normalImage = UIImage(named: "\(IMG_FORMAT)\(imageName)")
        let selectedImage = UIImage(named: "\(IMG_FORMAT)\(imageName)\(IMG_FORMAT_SELECTED)")
        self.setImage(normalImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
        
        self.isSelected = false
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
