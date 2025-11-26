//
//  InvalidSyntax.swift
//  NSAutoAXKit Test Fixtures
//
//  File with syntax errors for error handling tests.
//  Note: This file intentionally has syntax errors for testing purposes.
//

import UIKit

class InvalidSyntaxViewController: UIViewController {
    
    @IBOutlet weak var validLabel: UILabel!
    
    // Missing type annotation - but Swift can infer from assignment
    @IBOutlet weak var missingType = UIButton()
    
    // This would be a syntax error if uncommented:
    // @IBOutlet weak var syntaxError: UILabel
    // missing value or initialization
}

// Incomplete class definition for testing parser robustness
class IncompleteClass: UIViewController {
    @IBOutlet weak var label: UILabel!
    // Missing closing brace intentionally for parser testing

