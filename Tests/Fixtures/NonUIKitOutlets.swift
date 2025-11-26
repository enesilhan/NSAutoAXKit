//
//  NonUIKitOutlets.swift
//  NSAutoAXKit Test Fixtures
//
//  View controller with mixed UIKit and custom outlets for filtering tests.
//

import UIKit

// Custom type that's not a UIKit control
class CustomControl {
    var value: String = ""
}

class CustomView {
    var data: [String] = []
}

class MixedOutletsViewController: UIViewController {
    
    // UIKit outlets - should be included
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    // Non-UIKit outlets - should be skipped
    @IBOutlet weak var customControl: CustomControl!
    @IBOutlet weak var customView: CustomView?
    
    // UIKit outlets again
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Non-UIKit class - should be completely ignored
class NonUIKitClass {
    @IBOutlet weak var someProperty: UILabel!
    
    // This class doesn't inherit from UIViewController/UIView
    // so it should not be processed at all
}

