//
//  AutoAXTests.swift
//  NSAutoAXKitTests
//
//  Tests for the main AutoAX utility struct.
//

import XCTest
import UIKit
@testable import NSAutoAXKit

final class AutoAXTests: XCTestCase {
    
    func testVersionString() {
        let version = AutoAX.version
        
        XCTAssertFalse(version.isEmpty)
        XCTAssertTrue(version.contains("."), "Version should be in semantic versioning format")
    }
    
    func testLoggingDisabledByDefault() {
        XCTAssertFalse(AutoAX.loggingEnabled, "Logging should be disabled by default")
    }
    
    func testLoggingCanBeEnabled() {
        let originalValue = AutoAX.loggingEnabled
        
        AutoAX.loggingEnabled = true
        XCTAssertTrue(AutoAX.loggingEnabled)
        
        AutoAX.loggingEnabled = false
        XCTAssertFalse(AutoAX.loggingEnabled)
        
        // Restore original value
        AutoAX.loggingEnabled = originalValue
    }
    
    func testApplyToViewController() {
        let viewController = UIViewController()
        
        // Should not crash even if no extension exists
        XCTAssertNoThrow(AutoAX.apply(to: viewController))
    }
    
    func testApplyToView() {
        let view = UIView()
        
        // Should not crash even if no extension exists
        XCTAssertNoThrow(AutoAX.apply(to: view))
    }
}

// Test view controller with applyAutoAX method
class TestViewController: UIViewController {
    var applyAutoAXCalled = false
    
    @objc func applyAutoAX() {
        applyAutoAXCalled = true
    }
}

// Test view controller without applyAutoAX method
class PlainViewController: UIViewController {
    // No applyAutoAX method
}

final class AutoAXIntegrationTests: XCTestCase {
    
    func testApplyAutoAXIfAvailableCallsMethod() {
        let testVC = TestViewController()
        
        XCTAssertFalse(testVC.applyAutoAXCalled)
        
        testVC.applyAutoAXIfAvailable()
        
        XCTAssertTrue(testVC.applyAutoAXCalled, "applyAutoAX should have been called")
    }
    
    func testApplyAutoAXIfAvailableDoesNotCrashWithoutMethod() {
        let plainVC = PlainViewController()
        
        // Should not crash when method doesn't exist
        XCTAssertNoThrow(plainVC.applyAutoAXIfAvailable())
    }
}

