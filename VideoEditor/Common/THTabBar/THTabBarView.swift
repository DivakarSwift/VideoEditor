//
//  THTabBarView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 6/1/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

enum THTabBarViewAnchor: Int {
    case top = 0
    case bottom = 1
}


protocol THTabBarDelegate {
    func tabBar(_ tabBar: THTabBarView, canSelectTabAt index: Int) -> Bool
    func tabBar(_ tabBar: THTabBarView, didSelectTabAt index: Int)
}

class THTabBarView: UIView {
    
    let BUTTON_MARGIN: CGFloat = 10.0
    let BUTTON_WIDTH: CGFloat = 56.0

    var delegate: THTabBarDelegate?
    
    fileprivate var tabBarButtons: [THTabBarButton]?
    
    func setTabBarButtons(buttons: [THTabBarButton]) {
        if self.tabBarButtons != nil {
            for button in self.tabBarButtons! {
                button.removeFromSuperview()
            }
        }
        
        self.tabBarButtons = buttons
        
        if self.tabBarButtons != nil && (self.tabBarButtons?.count)! > 0 {
            self.tabBarButtons![0].isSelected = true
            self.selectedTabBarButton = self.tabBarButtons![0]
            if self.delegate != nil {
                self.delegate?.tabBar(self, didSelectTabAt: 0)
            }
        }
        
        for button in self.tabBarButtons! {
            button.addTarget(self, action: #selector(selectTabIfAllowed(_:)), for: .touchDown)
        }
        self.setNeedsLayout()
    }
    
    var selectedTabBarButton: THTabBarButton?
    var selectedTabBarButtonIndex: Int?
    dynamic var backgroundImage: UIImage? {
        get {
            return self.backgroundImageView?.image
        }
        set(image) {
            self.backgroundImageView?.image = image
        }
    }
    
    var backgroundImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleTopMargin.rawValue)
        self.backgroundImageView = UIImageView(frame: frame)
        self.addSubview(self.backgroundImageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectedTabbarButtonIndex() -> Int {
        return (self.tabBarButtons?.index(of: self.selectedTabBarButton!))!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundImageView?.frame = self.bounds
        let buttonLayoutWidth = (BUTTON_WIDTH * CGFloat((self.tabBarButtons?.count)!)) + (BUTTON_MARGIN * CGFloat((self.tabBarButtons?.count)! - 1))
        let startOrigin = (self.bounds.width - buttonLayoutWidth) / 2
        let buttonMargin = BUTTON_MARGIN
        var frame = CGRect(x: startOrigin, y: self.bounds.origin.y + 5.0, width: BUTTON_WIDTH, height: self.bounds.size.height - 8)
        for button in self.tabBarButtons! {
            button.frame = frame
            self.addSubview(button)
            frame.origin.x = frame.origin.x + buttonMargin + frame.size.width
        }
    }
    
    func selectTabIfAllowed(_ sender: THTabBarButton?) {
        if self.delegate != nil && (self.delegate?.tabBar(self, canSelectTabAt: (self.tabBarButtons?.index(of: sender!))!))!{
            if self.selectedTabBarButton == nil || self.selectedTabBarButton != sender! {
                for item in self.tabBarButtons! {
                    item.isSelected = false
                }
                sender?.isSelected = true
                self.selectedTabBarButton = sender
                
                self.delegate?.tabBar(self, didSelectTabAt: (self.tabBarButtons?.index(of: sender!))!)
            }
        }
    }
}
