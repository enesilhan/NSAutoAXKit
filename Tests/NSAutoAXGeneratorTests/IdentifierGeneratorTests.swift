//
//  IdentifierGeneratorTests.swift
//  NSAutoAXGeneratorTests
//
//  Tests for the identifier generation logic.
//

import XCTest
@testable import NSAutoAXGenerator

final class IdentifierGeneratorTests: XCTestCase {
    
    var generator: IdentifierGenerator!
    
    override func setUp() {
        super.setUp()
        generator = IdentifierGenerator(verbose: false)
    }
    
    func testGenerateIdentifiersForViewController() {
        let outlets = [
            OutletProperty(name: "titleLabel", typeName: "UILabel!", isOptional: true),
            OutletProperty(name: "submitButton", typeName: "UIButton!", isOptional: true)
        ]
        
        let typeDef = TypeDefinition(
            name: "LoginViewController",
            sourceFilePath: "/test/LoginViewController.swift",
            outlets: outlets,
            inheritedTypes: ["UIViewController"]
        )
        
        let result = generator.generateIdentifiers(for: [typeDef])
        
        XCTAssertEqual(result.count, 1)
        XCTAssertNotNil(result["LoginViewController"])
        
        let identifiers = result["LoginViewController"]!
        XCTAssertEqual(identifiers.count, 2)
        
        XCTAssertEqual(identifiers[0].identifier, "LoginViewController.titleLabel")
        XCTAssertEqual(identifiers[1].identifier, "LoginViewController.submitButton")
    }
    
    func testGenerateIdentifiersForView() {
        let outlets = [
            OutletProperty(name: "iconImageView", typeName: "UIImageView!", isOptional: true),
            OutletProperty(name: "nameLabel", typeName: "UILabel!", isOptional: true)
        ]
        
        let typeDef = TypeDefinition(
            name: "HeaderView",
            sourceFilePath: "/test/HeaderView.swift",
            outlets: outlets,
            inheritedTypes: ["UIView"]
        )
        
        let result = generator.generateIdentifiers(for: [typeDef])
        
        XCTAssertEqual(result.count, 1)
        let identifiers = result["HeaderView"]!
        
        XCTAssertEqual(identifiers[0].identifier, "HeaderView.iconImageView")
        XCTAssertEqual(identifiers[1].identifier, "HeaderView.nameLabel")
    }
    
    func testFilterNonUIKitTypes() {
        let outlets = [
            OutletProperty(name: "label", typeName: "UILabel!", isOptional: true)
        ]
        
        let typeDef = TypeDefinition(
            name: "CustomClass",
            sourceFilePath: "/test/CustomClass.swift",
            outlets: outlets,
            inheritedTypes: ["NSObject"] // Not a UIKit type
        )
        
        let result = generator.generateIdentifiers(for: [typeDef])
        
        XCTAssertEqual(result.count, 0, "Should not generate for non-UIKit types")
    }
    
    func testFilterNonUIKitOutlets() {
        let outlets = [
            OutletProperty(name: "titleLabel", typeName: "UILabel!", isOptional: true),
            OutletProperty(name: "customControl", typeName: "CustomControl!", isOptional: true)
        ]
        
        let typeDef = TypeDefinition(
            name: "MixedViewController",
            sourceFilePath: "/test/MixedViewController.swift",
            outlets: outlets,
            inheritedTypes: ["UIViewController"]
        )
        
        let result = generator.generateIdentifiers(for: [typeDef])
        
        let identifiers = result["MixedViewController"]!
        XCTAssertEqual(identifiers.count, 1, "Should only generate for UIKit outlets")
        XCTAssertEqual(identifiers[0].propertyName, "titleLabel")
    }
    
    func testDuplicatePropertyNames() {
        let outlets = [
            OutletProperty(name: "button", typeName: "UIButton!", isOptional: true),
            OutletProperty(name: "button", typeName: "UIButton!", isOptional: true),
            OutletProperty(name: "button", typeName: "UIButton!", isOptional: true)
        ]
        
        let typeDef = TypeDefinition(
            name: "DuplicateViewController",
            sourceFilePath: "/test/DuplicateViewController.swift",
            outlets: outlets,
            inheritedTypes: ["UIViewController"]
        )
        
        let result = generator.generateIdentifiers(for: [typeDef])
        
        let identifiers = result["DuplicateViewController"]!
        XCTAssertEqual(identifiers.count, 3)
        
        // First one should have original name
        XCTAssertEqual(identifiers[0].propertyName, "button")
        
        // Subsequent ones should have indices
        XCTAssertEqual(identifiers[1].propertyName, "button_1")
        XCTAssertEqual(identifiers[2].propertyName, "button_2")
    }
    
    func testValidateIdentifiers() {
        let identifiers = [
            GeneratedIdentifier(ownerType: "TestVC", propertyName: "label1"),
            GeneratedIdentifier(ownerType: "TestVC", propertyName: "label2"),
            GeneratedIdentifier(ownerType: "TestVC", propertyName: "label3")
        ]
        
        let warnings = generator.validateIdentifiers(["TestVC": identifiers])
        
        XCTAssertEqual(warnings.count, 0, "Valid identifiers should produce no warnings")
    }
    
    func testMultipleTypes() {
        let type1 = TypeDefinition(
            name: "FirstViewController",
            sourceFilePath: "/test/First.swift",
            outlets: [
                OutletProperty(name: "label", typeName: "UILabel!", isOptional: true)
            ],
            inheritedTypes: ["UIViewController"]
        )
        
        let type2 = TypeDefinition(
            name: "SecondViewController",
            sourceFilePath: "/test/Second.swift",
            outlets: [
                OutletProperty(name: "button", typeName: "UIButton!", isOptional: true)
            ],
            inheritedTypes: ["UIViewController"]
        )
        
        let result = generator.generateIdentifiers(for: [type1, type2])
        
        XCTAssertEqual(result.count, 2)
        XCTAssertNotNil(result["FirstViewController"])
        XCTAssertNotNil(result["SecondViewController"])
    }
}

