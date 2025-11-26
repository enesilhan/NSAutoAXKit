//
//  SampleViewController.swift
//  NSAutoAXKit Test Fixtures
//
//  Sample view controller for testing the generator.
//

import UIKit

class SampleViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var headerImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup code would go here
    }
}

