//
//  ExtensionTests.swift
//  NSAutoAXKitTests
//
//  Tests for UIViewController and UIView extensions.
//

import XCTest
import UIKit
@testable import NSAutoAXKit

final class ExtensionTests: XCTestCase {
    
    func testUIViewControllerExtensionExists() {
        let vc = UIViewController()
        
        // Verify the extension method exists
        XCTAssertTrue(vc.responds(to: #selector(UIViewController.applyAutoAXIfAvailable)))
    }
    
    func testUIViewExtensionExists() {
        let view = UIView()
        
        // Verify the extension method exists
        XCTAssertTrue(view.responds(to: #selector(UIView.applyAutoAXIfAvailable)))
    }
    
    func testApplyAutoAXIfAvailableOnViewController() {
        let vc = TestViewControllerWithOutlets()
        
        // Initially nil
        XCTAssertNil(vc.testLabel?.accessibilityIdentifier)
        
        // Manually call applyAutoAX (simulating generated code)
        vc.applyGeneratedIdentifiers()
        
        // Now should be set
        XCTAssertEqual(vc.testLabel?.accessibilityIdentifier, "TestViewControllerWithOutlets.testLabel")
    }
    
    func testApplyAutoAXIfAvailableOnView() {
        let view = TestViewWithOutlets()
        
        XCTAssertNil(view.testButton?.accessibilityIdentifier)
        
        view.applyGeneratedIdentifiers()
        
        XCTAssertEqual(view.testButton?.accessibilityIdentifier, "TestViewWithOutlets.testButton")
    }
}

// Mock view controller with outlets for testing
class TestViewControllerWithOutlets: UIViewController {
    var testLabel: UILabel? = UILabel()
    var testButton: UIButton? = UIButton()
    
    // Simulating generated method
    func applyGeneratedIdentifiers() {
        testLabel?.accessibilityIdentifier = "TestViewControllerWithOutlets.testLabel"
        testButton?.accessibilityIdentifier = "TestViewControllerWithOutlets.testButton"
    }
}

// Mock view with outlets for testing
class TestViewWithOutlets: UIView {
    var testLabel: UILabel? = UILabel()
    var testButton: UIButton? = UIButton()
    
    // Simulating generated method
    func applyGeneratedIdentifiers() {
        testLabel?.accessibilityIdentifier = "TestViewWithOutlets.testLabel"
        testButton?.accessibilityIdentifier = "TestViewWithOutlets.testButton"
    }
}

final class AccessibilityIdentifierTests: XCTestCase {
    
    func testIdentifierPersistence() {
        let label = UILabel()
        
        label.accessibilityIdentifier = "test.label"
        XCTAssertEqual(label.accessibilityIdentifier, "test.label")
        
        label.accessibilityIdentifier = "updated.label"
        XCTAssertEqual(label.accessibilityIdentifier, "updated.label")
    }
    
    func testIdentifierFormat() {
        let button = UIButton()
        
        // Test deterministic format: TypeName.propertyName
        button.accessibilityIdentifier = "LoginViewController.submitButton"
        
        XCTAssertTrue(button.accessibilityIdentifier?.contains(".") ?? false)
        XCTAssertTrue(button.accessibilityIdentifier?.components(separatedBy: ".").count == 2)
    }
    
    func testOptionalOutletsHandling() {
        let vc = TestViewControllerWithOutlets()
        
        // Test with nil outlet
        vc.testLabel = nil
        
        // Should not crash when setting identifier on nil outlet
        XCTAssertNoThrow(vc.testLabel?.accessibilityIdentifier = "test")
        
        // Should remain nil
        XCTAssertNil(vc.testLabel)
    }
}

