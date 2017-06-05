//
//  AppDelegate.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainViewController: THMainViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let _ = mainViewController?.prefersStatusBarHidden
        mainViewController = self.window?.rootViewController as? THMainViewController
        
        let bgImage = #imageLiteral(resourceName: "tb_background")
        bgImage.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3))
        THTabBarView.appearance().backgroundImage = bgImage
        
        let navbarImage = #imageLiteral(resourceName: "app_navbar_background")
        navbarImage.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3))
        mainViewController?.navigationController?.navigationBar.setBackgroundImage(navbarImage, for: .default)
        
        return true
    }

    static func sharedDelegate() -> AppDelegate {
        return (UIApplication.shared.delegate as? AppDelegate)!
    }
    
    func prepareMainViewController() {
        self.mainViewController?.timelineViewController = self.childViewController(ofType: THTimelineViewController.classForCoder()) as? THTimelineViewController
        self.mainViewController?.playerViewController = self.childViewController(ofType: THPlayerViewController.classForCoder()) as? THPlayerViewController
        self.mainViewController?.videoPickerViewController = self.childViewController(ofType: THVideoPickerViewController.classForCoder()) as? THVideoPickerViewController
        self.mainViewController?.audioPickerViewController = self.childViewController(ofType: THAudioPickerViewController.classForCoder()) as? THAudioPickerViewController
        self.mainViewController?.videoPickerViewController?.playbackMediator = self.mainViewController
        self.mainViewController?.audioPickerViewController?.playbackMediator = self.mainViewController
        self.mainViewController?.playerViewController?.playbackMediator = self.mainViewController
        
        assert(self.mainViewController?.timelineViewController != nil, "THTimelineViewController not set.")
        assert(self.mainViewController?.playerViewController != nil, "THPlayerViewController not set.")
        assert(self.mainViewController?.videoPickerViewController != nil, "THVideoPickerViewController not set.")
        assert(self.mainViewController?.audioPickerViewController != nil, "THAudioPickerViewController not set.")
    }
    
    func childViewController(ofType type: AnyClass) -> UIViewController? {
        for controller in (self.mainViewController?.childViewControllers)! {
            if controller.classForCoder == type {
                return controller
            }
            if controller is THTabBarController {
                for childController in controller.childViewControllers {
                    let navcontroller = childController as? UINavigationController
                    if String(describing: navcontroller?.topViewController.self).contains(String(describing: type)) {
                        return (navcontroller?.topViewController)!
                    }
                }
            }
        }
        assert(false, "Request controller of type \(type) was not found.")
        return nil
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

