/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom app delegate for the LoopHealth app. Manages an app-wide `HKHealthStore` instance.
 */

import UIKit
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?

    let healthStore: HKHealthStore

    // MARK: - Initializers

    override init() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        
        healthStore = HKHealthStore()
    }
    
    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Enumerate the view controller heirarchy, setting the health store where appropriate.
        window?.rootViewController?.enumerateHierarchy { viewController in
            guard var healthStoreContainer = viewController as? HealthStoreContainer else { return }
            healthStoreContainer.healthStore = healthStore
        }
        
        return true
    }
}
