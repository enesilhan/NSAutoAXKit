//
//  SourceParserTests.swift
//  NSAutoAXGeneratorTests
//
//  Tests for the SwiftSyntax-based source parser.
//

import XCTest
@testable import NSAutoAXGenerator

final class SourceParserTests: XCTestCase {
    
    var parser: SourceParser!
    var fixturesPath: String!
    
    override func setUp() {
        super.setUp()
        parser = SourceParser(verbose: false)
        
        // Get path to Fixtures directory
        let testBundle = Bundle.module
        fixturesPath = testBundle.resourcePath.flatMap { path in
            (path as NSString).appendingPathComponent("Fixtures")
        }
        
        XCTAssertNotNil(fixturesPath, "Fixtures path should exist")
    }
    
    func testParseSampleViewController() throws {
        let filePath = (fixturesPath as NSString).appendingPathComponent("SampleViewController.swift")
        
        let types = try parser.parse(file: filePath)
        
        XCTAssertEqual(types.count, 1, "Should find one type definition")
        
        let viewController = types[0]
        XCTAssertEqual(viewController.name, "SampleViewController")
        XCTAssertTrue(viewController.isUIKitType)
        XCTAssertEqual(viewController.outlets.count, 6, "Should have 6 outlets")
        
        let outletNames = viewController.outlets.map { $0.name }
        XCTAssertTrue(outletNames.contains("titleLabel"))
        XCTAssertTrue(outletNames.contains("primaryButton"))
        XCTAssertTrue(outletNames.contains("emailTextField"))
    }
    
    func testParseSampleView() throws {
        let filePath = (fixturesPath as NSString).appendingPathComponent("SampleView.swift")
        
        let types = try parser.parse(file: filePath)
        
        XCTAssertEqual(types.count, 1)
        
        let view = types[0]
        XCTAssertEqual(view.name, "SampleView")
        XCTAssertTrue(view.isUIKitType)
        XCTAssertEqual(view.outlets.count, 4)
    }
    
    func testParseSampleCell() throws {
        let filePath = (fixturesPath as NSString).appendingPathComponent("SampleCell.swift")
        
        let types = try parser.parse(file: filePath)
        
        XCTAssertEqual(types.count, 2, "Should find both table view cell and collection view cell")
        
        let tableCell = types.first { $0.name == "SampleTableViewCell" }
        XCTAssertNotNil(tableCell)
        XCTAssertEqual(tableCell?.outlets.count, 4)
        
        let collectionCell = types.first { $0.name == "SampleCollectionViewCell" }
        XCTAssertNotNil(collectionCell)
        XCTAssertEqual(collectionCell?.outlets.count, 3)
    }
    
    func testParseMultipleOutlets() throws {
        let filePath = (fixturesPath as NSString).appendingPathComponent("MultipleOutlets.swift")
        
        let types = try parser.parse(file: filePath)
        
        XCTAssertEqual(types.count, 1)
        
        let viewController = types[0]
        XCTAssertEqual(viewController.name, "MultipleOutletsViewController")
        XCTAssertGreaterThan(viewController.outlets.count, 15, "Should have many outlets")
        
        // Verify various UIKit control types are detected
        let typeNames = viewController.outlets.map { $0.typeName }
        XCTAssertTrue(typeNames.contains { $0.contains("UILabel") })
        XCTAssertTrue(typeNames.contains { $0.contains("UIButton") })
        XCTAssertTrue(typeNames.contains { $0.contains("UITextField") })
    }
    
    func testParseNoOutlets() throws {
        let filePath = (fixturesPath as NSString).appendingPathComponent("NoOutlets.swift")
        
        let types = try parser.parse(file: filePath)
        
        // Should find no types because they have no outlets
        XCTAssertEqual(types.count, 0, "Should find no types without outlets")
    }
    
    func testParseNonUIKitOutlets() throws {
        let filePath = (fixturesPath as NSString).appendingPathComponent("NonUIKitOutlets.swift")
        
        let types = try parser.parse(file: filePath)
        
        // Should find MixedOutletsViewController
        let mixedVC = types.first { $0.name == "MixedOutletsViewController" }
        XCTAssertNotNil(mixedVC)
        
        // Should include all outlets (filtering happens in IdentifierGenerator)
        XCTAssertEqual(mixedVC?.outlets.count, 5)
        
        // NonUIKitClass should be found but filtered out by isUIKitType
        let nonUIKit = types.first { $0.name == "NonUIKitClass" }
        if let nonUIKit = nonUIKit {
            XCTAssertFalse(nonUIKit.isUIKitType, "NonUIKitClass should not be a UIKit type")
        }
    }
    
    func testDiscoverSwiftFiles() {
        let files = SourceParser.discoverSwiftFiles(in: [fixturesPath])
        
        XCTAssertGreaterThan(files.count, 0, "Should discover Swift files")
        
        let fileNames = files.map { ($0 as NSString).lastPathComponent }
        XCTAssertTrue(fileNames.contains("SampleViewController.swift"))
        XCTAssertTrue(fileNames.contains("SampleView.swift"))
    }
    
    func testFileNotFound() {
        let nonExistentPath = "/path/to/nonexistent/file.swift"
        
        XCTAssertThrowsError(try parser.parse(file: nonExistentPath)) { error in
            if let genError = error as? GeneratorError {
                switch genError {
                case .fileNotFound:
                    break // Expected
                default:
                    XCTFail("Expected fileNotFound error, got \(genError)")
                }
            } else {
                XCTFail("Expected GeneratorError")
            }
        }
    }
}

