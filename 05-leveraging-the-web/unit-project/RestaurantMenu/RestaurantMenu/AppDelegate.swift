//
//  AppDelegate.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var stateController = StateController()
    var menuModelController = MenuModelController()
    
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return false
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return false
    }
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        stateController.loadPersistedCurrentOrder()
        
        menuModelController.loadPersistedMenuItems()
        menuModelController.fetchRemoteData()
        
        return true
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        injectControllers()
        setupNotificationListeners()
        setupURLCache()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        stateController.persistCurrentOrder()
        menuModelController.persistMenuItems()
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


// MARK: - Private Helper Methods

private extension AppDelegate {
    
    func injectControllers() {
        guard
            let tabBarController = window?.rootViewController as? UITabBarController,
            let menuNavController = tabBarController.viewControllers?[0] as? UINavigationController,
            let orderNavController = tabBarController.viewControllers?[1] as? UINavigationController,
            let categoryListVC = menuNavController.topViewController as? CategoriesListViewController,
            let pendingOrderListVC = orderNavController.topViewController as? PendingOrderListViewController
        else {
            preconditionFailure("Unable to find expected view controllers")
        }

        categoryListVC.stateController = stateController
        pendingOrderListVC.stateController = stateController
        
        categoryListVC.modelController = menuModelController
    }


    @objc func menuItemAddedToOrder() {
        guard
            let tabBarController = window?.rootViewController as? UITabBarController,
            let orderNavController = tabBarController.viewControllers?[1] as? UINavigationController
        else {
            preconditionFailure("Unable to find expected view controllers")
        }
        
        let newBadgeValue: String? = stateController.currentOrder.menuItems.count == 0 ?
            nil : "\(stateController.currentOrder.menuItems.count)"
        
        orderNavController.tabBarItem.badgeValue = newBadgeValue
    }


    func setupNotificationListeners() {
        defaultNotificationCenter.addObserver(
            self,
            selector: #selector(menuItemAddedToOrder),
            name: .StateControllerOrderUpdated,
            object: nil
        )
    }
    
    
    /**
     Alot extra cache memory for all of our images.
     */
    func setupURLCache() {
        let temporaryDirectory = NSTemporaryDirectory()
        let cache = URLCache(
            memoryCapacity: 25_000_000,
            diskCapacity: 50_000_000,
            diskPath: temporaryDirectory
        )
        
        URLCache.shared = cache
    }
}

extension AppDelegate: AppNotifiable {}
