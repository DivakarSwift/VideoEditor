//
//  THTabBarControllerView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 6/1/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTabBarControllerView: UIView {

    let TAB_BAR_HEIGHT: CGFloat = 49.0
    
    var tabBarView: THTabBarView?
    private var tabBarAnchor: THTabBarAnchor?
    func setTabBarAnchor(tabBarAnchor: THTabBarAnchor) {
        self.tabBarAnchor = tabBarAnchor
        if self.tabBarAnchor == THTabBarAnchor.top {
            self.tabBarView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: TAB_BAR_HEIGHT)
            self.tabBarView?.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleBottomMargin.rawValue | UIViewAutoresizing.flexibleWidth.rawValue)
        }
        else {
            self.tabBarView?.frame = CGRect(x: 0, y: self.bounds.height - TAB_BAR_HEIGHT, width: self.bounds.width, height: TAB_BAR_HEIGHT)
            self.tabBarView?.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleTopMargin.rawValue | UIViewAutoresizing.flexibleWidth.rawValue)
        }
        self.contentView?.frame = self.contentFrameForCurrentAnchorPosition()
        self.setNeedsLayout()
    }
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tabBarView = THTabBarView(frame: CGRect.zero)
        self.addSubview(self.tabBarView!)
        self.setTabBarAnchor(tabBarAnchor: THTabBarAnchor.bottom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contentFrameForCurrentAnchorPosition() -> CGRect {
        let frame: CGRect
        if self.tabBarAnchor == THTabBarAnchor.top {
            frame = CGRect(x: 0, y: TAB_BAR_HEIGHT, width: self.bounds.width, height: (self.tabBarView?.bounds.size.height)!)
        }
        else {
            frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.size.height - (self.tabBarView?.bounds.size.height)!)
        }
        return frame
    }
    
    func setContentView(newContentView: UIView, animated: Bool, options: THTabBarAnimationOption) {
        if self.contentView == nil {
            newContentView.frame = self.contentFrameForCurrentAnchorPosition()
            self.contentView = newContentView
            self.addSubview(self.contentView!)
            self.sendSubview(toBack: self.contentView!)
        }
        else {
            let oldContentView = self.contentView
            newContentView.frame = self.contentFrameForCurrentAnchorPosition()
            self.contentView = newContentView
            self.addSubview(self.contentView!)
            self.sendSubview(toBack: self.contentView!)
            oldContentView?.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - TAB_BAR_HEIGHT)
        self.tabBarView?.frame = CGRect(x: 0, y: self.bounds.height - TAB_BAR_HEIGHT, width: self.bounds.width, height: TAB_BAR_HEIGHT)
    }
}
