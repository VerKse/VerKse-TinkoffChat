//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Vera on 16.02.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let navigationController = UINavigationController.init(rootViewController: ConversationsListViewController())
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        
        if (ProcessInfo.processInfo.environment["AD_LIFESYCLE_LOGS"] == "consolePrint") {
            print ("Application moved from NOT RUNNING to INACTIVE: application")
        }
        return true
    }
    
    // MARK: LifecycleF
    
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if (ProcessInfo.processInfo.environment["AD_LIFESYCLE_LOGS"] == "consolePrint") {
            print ("Application moved to NOT RUNNING: application")
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication){
        if (ProcessInfo.processInfo.environment["AD_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from INACTIVE to ACTIVE: applicationDidBecomeActive")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication){
        if (ProcessInfo.processInfo.environment["AD_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from ACTIVE to INACTIVE: applicationWillResignActive")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication){
        if (ProcessInfo.processInfo.environment["AD_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from INACTIVE to BACKGROUND: applicationDidEnterBackground")
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication){
        if (ProcessInfo.processInfo.environment["AD_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from BACKGROUND to INACTIVE: applicationWillEnterForeground")
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.instance.saveContext()
        
        if (ProcessInfo.processInfo.environment["AD_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from ACTIVE to NOT ACTIVE: applicationWillTerminate")
        }
    }
    
}

