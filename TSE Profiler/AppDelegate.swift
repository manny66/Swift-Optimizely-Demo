//
//  AppDelegate.swift
//  TSE Profiler
//
//  Created by Mansoor Omar on 13/5/20.
//  Copyright © 2020 Mansoor Omar. All rights reserved.
//

import UIKit
import RealmSwift
import Optimizely


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Build and config OptimizelyClient
    let optimizely = OptimizelyClient(sdkKey: "QQJNMaYs9cLijynKsDme4o", periodicDownloadInterval: 30)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Instantiate the client asynchronously with a callback
            optimizely.start { result in
                switch result {
                case .failure(let error):
                 print("Optimizely SDK initiliazation failed: \(error)")
                case .success:
                 print("Optimizely SDK initialized successfully!")
                }
            }
        
        // get location of storage
         print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

