//
//  THTabBarController.swift
//  VideoEditor
//
//  Created by Mobdev125 on 6/1/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

enum THTabBarAnchor: Int {
    case top = 0
    case bottom = 1
}

enum THTabBarAnimationOption: Int {
    case rightToLeft = 0
    case leftToRight = 1
}

protocol THTabBarControllerDelegate {
    func tabBarController(_ tabBarController: THTabBarController, shouldSelect viewController: UIViewController) -> Bool
    func tabBarController(_ tabBarController: THTabBarController, didSelect viewController: UIViewController)
}

class THTabBarController: UIViewController {

    let THTabBarControllerTabChangedNotification = "THTabBarControllerTabChangedNotification"
    let STATUS_BAR_HEIGHT:CGFloat = 20.0
    
    var delegate: THTabBarControllerDelegate?
    var tabBarItems: [THTabBarItem]? = [THTabBarItem]()
    
    func setTabBarItems(tabBarItems: [THTabBarItem]!) {
        if self.tabBarItems! != tabBarItems {
            for item in self.tabBarItems! {
                item.controller?.willMove(toParentViewController: nil)
                item.controller?.removeFromParentViewController()
            }
            
            self.tabBarItems = tabBarItems
            for item in self.tabBarItems! {
                self.addChildViewController(item.controller!)
                item.controller?.didMove(toParentViewController: self)
            }
        }
    }
    
    fileprivate var selectedViewController: UIViewController?
    func setSelectedViewController(newViewController: UIViewController) {
        if self.selectedViewController == newViewController {
            return
        }
        
        let fromIndex = self.selectedIndex
        let oldViewController = self.selectedViewController
        self.selectedViewController = newViewController
        let toIndex = self.selectedIndex
        if oldViewController != nil {
            (self.view as? THTabBarControllerView)?.setContentView(newContentView: (self.selectedViewController?.view)!, animated: false, options: THTabBarAnimationOption(rawValue: 0)!)
        }
        else {
            let direction = fromIndex! < toIndex! ? THTabBarAnimationOption.rightToLeft : THTabBarAnimationOption.leftToRight
            (self.view as? THTabBarControllerView)?.setContentView(newContentView: (self.selectedViewController?.view)!, animated: false, options: direction)
        }
        
        for i in 0..<(self.tabBarItems?.count)! {
            let item = self.tabBarItems![i]
            item.button?.isSelected = (item.controller == self.selectedViewController)
            if (item.button?.isSelected)! {
                self.lastSelectedIndex = i
            }
            item.button?.setNeedsLayout()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: THTabBarControllerTabChangedNotification), object: nil)
    }
    var selectedIndex: Int? {
        get {
            for i in 0..<(self.tabBarItems?.count)! {
                if self.tabBarItems![i].controller == self.selectedViewController {
                    return i
                }
            }
            return 0
        }
        set(index) {
            assert(index! <= (self.tabBarItems?.count)!, "\(String(describing: index)) is an invalid index.")
            let viewController = self.tabBarItems?[index!].controller!
            self.selectedViewController = viewController
        }
    }
    fileprivate var tabBarAnchor: THTabBarAnchor?
    func setTabBarAnchor(tabBarAnchor: THTabBarAnchor) {
        self.tabBarAnchor = tabBarAnchor
        (self.view as? THTabBarControllerView)?.setTabBarAnchor(tabBarAnchor: tabBarAnchor)
        self.view.setNeedsLayout()
    }
    
    var animateTransitions: Bool?
    var lastSelectedIndex: Int?
    
    func setup() {
        self.lastSelectedIndex = 0
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.performSegue(withIdentifier: "THSetVideoPickerViewController", sender: self)
        self.performSegue(withIdentifier: "THSetAudioPickerViewController", sender: self)
    }
    
    override func loadView() {
        super.loadView()
        self.view = THTabBarControllerView(frame: CGRect.zero)
        self.view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue)
        
        var buttons = [THTabBarButton]()
        for item in self.tabBarItems! {
            let button = THTabBarButton(withImageName: item.imageName!)
            item.button = button
            buttons.append(button)
        }
        
        let tabBarView = (self.view as? THTabBarControllerView)?.tabBarView
        tabBarView?.setTabBarButtons(buttons: buttons)
        tabBarView?.delegate = self
        
        self.setSelectedViewController(newViewController: (self.tabBarItems?[0].controller!)!)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        self.selectedIndex = self.lastSelectedIndex
    }
    
    override var shouldAutorotate: Bool {
        if self.selectedViewController != nil {
            return (self.selectedViewController?.shouldAutorotate)!
        }
        return true
    }
}

extension THTabBarController: THTabBarDelegate {
    func tabBar(_ tabBar: THTabBarView, didSelectTabAt index: Int) {
        guard let viewController = self.tabBarItems?[index].controller! else {
            return
        }
        if self.selectedViewController == viewController && self.selectedViewController! is UINavigationController {
            (self.selectedViewController as? UINavigationController)?.popToViewController(self.selectedViewController!, animated: true)
        }
        else {
            self.setSelectedViewController(newViewController: viewController)
        }
        
        if self.delegate != nil {
            self.delegate?.tabBarController(self, didSelect: self.selectedViewController!)
        }
    }
    
    func tabBar(_ tabBar: THTabBarView, canSelectTabAt index: Int) -> Bool {
        if self.delegate != nil {
            return (self.delegate?.tabBarController(self, shouldSelect: self.tabBarItems![index].controller!))!
        }
        return true
    }
}
