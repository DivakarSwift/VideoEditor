//
//  THTabBarRelationshipSegue.swift
//  VideoEditor
//
//  Created by Mobdev125 on 6/1/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTabBarRelationshipSegue: UIStoryboardSegue {
    let VIEW_REGEX = "TH([A-Za-z]+)PickerViewController"
    override func perform() {
        let tabBarController = self.source as? THTabBarController
        var tabBarItems = tabBarController!.tabBarItems
        if tabBarItems == nil {
            tabBarItems = [THTabBarItem]()
        }
        
        let className = NSStringFromClass(self.destination.classForCoder)
        let imageName = className.stringByMatchingRegex(regex: VIEW_REGEX, capture: 1)
        let controller = UINavigationController(rootViewController: self.destination)
        controller.navigationBar.setBoundsHeight(newHeight: 64)
        controller.navigationBar.barStyle = .blackOpaque
//        let controller = self.destination
        tabBarItems?.append(THTabBarItem(withImageName: imageName!, viewController: controller))
        tabBarController?.setTabBarItems(tabBarItems: tabBarItems!)
    }
}

extension String {
    func stringByMatchingRegex(regex: String, capture: Int) -> String? {
        let expression = try! NSRegularExpression(pattern: regex, options: NSRegularExpression.Options(rawValue: 0))
        let result = expression.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count))
        if capture < (result?.numberOfRanges)! {
            let range = result?.rangeAt(capture)
            return (self as NSString).substring(with: range!) as String
        }
        return nil
    }
}
