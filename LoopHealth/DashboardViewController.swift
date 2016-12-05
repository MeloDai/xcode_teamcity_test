/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The first of two main view controllers for the LoopHealth app.
 */

import UIKit
import HealthKitUI

/**
    View controller for the first tab of the LoopHealth app. Displays user's
    doctor's name, upcoming appointments, and the user's daily activity rings.
 */
class DashboardViewController: UIViewController, HealthStoreContainer {

    // MARK: Properties
    
    @IBOutlet var activityRingView: HKActivityRingView!

    /**
        The `HKHealthStore` that this view controller should use to query data.
        It is expected that this property is set by the presenter of this view
        controller. For this sample, this is the application delegate.
    */
    var healthStore: HKHealthStore!
    
    // MARK: View Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
            Attempt authorization for activity summaries when the user views the
            Dashboard tab.
         */
        healthStore.requestAuthorization(toShare: nil, read: [HKObjectType.activitySummaryType()]) {
            success, error in
            
            // After requesting authorization, attempt to load data.
            self.updateActivitySummary()
        }
    }
    
    // MARK: Private Methods

    private func updateActivitySummary() {
        /*
            These are the calendar components required for fetching an
            `HKActivitySummary`.
         */
        let componentFlags: Set<Calendar.Component> = [.day, .month, .year, .era]
        var components = Calendar.current.dateComponents(componentFlags, from: Date())
        
        // Set the calendar used to calculate the components on the result.
        components.calendar = Calendar.current

        // Restrict query to activity summaries whose date corresponds to today.
        let predicate = NSPredicate(format: "%K = %@", argumentArray: [HKPredicateKeyPathDateComponents, components])

        let query = HKActivitySummaryQuery(predicate: predicate) { query, summaries, error in
            // There can only be one `HKActivitySummary` for a given day.
            guard let summary = summaries?.first else { return }
            
            // Update our rings with the retrieved data on the main queue.
            DispatchQueue.main.async {
                self.activityRingView.setActivitySummary(summary, animated: true)
            }
        }

        healthStore.execute(query)
    }
}

