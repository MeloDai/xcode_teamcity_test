/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A protocol that formally defines an object that has a `HKHealthStore` property.
 */

import HealthKit

protocol HealthStoreContainer {
    var healthStore: HKHealthStore! { get set }
}
