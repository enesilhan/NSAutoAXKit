//
//  NoOutlets.swift
//  NSAutoAXKit Test Fixtures
//
//  View controller with no @IBOutlet properties - should produce no output.
//

import UIKit

class NoOutletsViewController: UIViewController {
    
    // Regular properties (not outlets)
    var customProperty: String = ""
    let constantValue: Int = 42
    
    // Programmatic views (not outlets)
    lazy var programmaticLabel: UILabel = {
        let label = UILabel()
        label.text = "Created programmatically"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(programmaticLabel)
    }
}

class EmptyViewController: UIViewController {
    // Completely empty - no properties at all
}

