//
//  THTabBarItem.swift
//  VideoEditor
//
//  Created by Mobdev125 on 6/1/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTabBarItem: NSObject {
    var imageName: String?
    var controller: UIViewController?
    var button: THTabBarButton?
    
    init(withImageName imageName: String, viewController: UIViewController) {
        super.init()
        self.imageName = imageName
        self.controller = viewController
    }
}
