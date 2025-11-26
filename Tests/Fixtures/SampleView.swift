//
//  SampleView.swift
//  NSAutoAXKit Test Fixtures
//
//  Sample custom view for testing the generator.
//

import UIKit

class SampleView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup code would go here
    }
}

