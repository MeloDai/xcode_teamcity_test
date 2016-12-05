/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller for showing contents of a health document.
 */

import UIKit
import HealthKit

/// View controller for showing contents of a health document.
class RecordsDetailViewController: UIViewController, HealthStoreContainer {

    // MARK: Properties
    
    /**
        The `HKHealthStore` that this view controller should use to query data.
        It is expected that this property is set by the presenter of this view
        controller. For this sample, this is the application delegate.
    */
    var healthStore: HKHealthStore!

    var healthDocumentSample: HKCDADocumentSample!
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = healthDocumentSample.document?.title

        guard let documentType = HKObjectType.documentType(forIdentifier: .CDA), let healthDocumentSample = healthDocumentSample else { return }
        
        // Re-query for the object with document data using UUID.
        let healthDocumentPredicate = HKQuery.predicateForObject(with: healthDocumentSample.uuid)
        
        let healthDocumentsQuery = HKDocumentQuery(documentType: documentType, predicate:healthDocumentPredicate, limit: 1, sortDescriptors: nil, includeDocumentData: true) { _, samples, _, _ in
            // Check samples have been fetched.
            guard let samples = samples as? [HKCDADocumentSample] else { return }

            // Get raw document data and place into `UITextView`.
            guard let healthDocumentData = samples.first?.document?.documentData else { return }
            DispatchQueue.main.async {
                let text = NSString(data: healthDocumentData, encoding: String.Encoding.utf8.rawValue) as! String
                self.textView.text = text
            }
        }
        
        healthStore.execute(healthDocumentsQuery)
    }    
}
