//
//  JSONExporterTests.swift
//  NSAutoAXGeneratorTests
//
//  Tests for JSON export functionality.
//

import XCTest
@testable import NSAutoAXGenerator

final class JSONExporterTests: XCTestCase {
    
    var exporter: JSONExporter!
    var tempDirectory: String!
    
    override func setUp() {
        super.setUp()
        exporter = JSONExporter(verbose: false)
        
        tempDirectory = NSTemporaryDirectory()
            .appending("NSAutoAXKitTests-\(UUID().uuidString)")
        
        try? FileManager.default.createDirectory(
            atPath: tempDirectory,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(atPath: tempDirectory)
    }
    
    func testExportJSON() throws {
        let identifiers = [
            "LoginViewController": [
                GeneratedIdentifier(ownerType: "LoginViewController", propertyName: "emailField"),
                GeneratedIdentifier(ownerType: "LoginViewController", propertyName: "passwordField"),
                GeneratedIdentifier(ownerType: "LoginViewController", propertyName: "loginButton")
            ],
            "ProfileView": [
                GeneratedIdentifier(ownerType: "ProfileView", propertyName: "nameLabel"),
                GeneratedIdentifier(ownerType: "ProfileView", propertyName: "avatarImageView")
            ]
        ]
        
        let outputPath = (tempDirectory as NSString).appendingPathComponent("test.json")
        
        try exporter.exportJSON(identifiersByType: identifiers, to: outputPath)
        
        // Verify file exists
        XCTAssertTrue(FileManager.default.fileExists(atPath: outputPath))
        
        // Parse and verify JSON structure
        let data = try Data(contentsOf: URL(fileURLWithPath: outputPath))
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?["generated_at"])
        XCTAssertNotNil(json?["generator_version"])
        XCTAssertNotNil(json?["identifiers"])
        
        let identifiersDict = json?["identifiers"] as? [String: [String: String]]
        XCTAssertNotNil(identifiersDict)
        
        // Verify LoginViewController identifiers
        let loginVC = identifiersDict?["LoginViewController"]
        XCTAssertEqual(loginVC?["emailField"], "LoginViewController.emailField")
        XCTAssertEqual(loginVC?["passwordField"], "LoginViewController.passwordField")
        XCTAssertEqual(loginVC?["loginButton"], "LoginViewController.loginButton")
        
        // Verify ProfileView identifiers
        let profileView = identifiersDict?["ProfileView"]
        XCTAssertEqual(profileView?["nameLabel"], "ProfileView.nameLabel")
        XCTAssertEqual(profileView?["avatarImageView"], "ProfileView.avatarImageView")
    }
    
    func testExportEmptyJSON() throws {
        let outputPath = (tempDirectory as NSString).appendingPathComponent("empty.json")
        
        try exporter.exportJSON(identifiersByType: [:], to: outputPath)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: outputPath))
        
        let data = try Data(contentsOf: URL(fileURLWithPath: outputPath))
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        XCTAssertNotNil(json)
        
        let identifiersDict = json?["identifiers"] as? [String: [String: String]]
        XCTAssertEqual(identifiersDict?.count, 0)
    }
    
    func testJSONIsPrettyPrinted() throws {
        let identifiers = [
            "TestVC": [
                GeneratedIdentifier(ownerType: "TestVC", propertyName: "label")
            ]
        ]
        
        let outputPath = (tempDirectory as NSString).appendingPathComponent("pretty.json")
        
        try exporter.exportJSON(identifiersByType: identifiers, to: outputPath)
        
        let contents = try String(contentsOfFile: outputPath, encoding: .utf8)
        
        // Pretty printed JSON should have newlines and indentation
        XCTAssertTrue(contents.contains("\n"))
        XCTAssertTrue(contents.contains("  ")) // Indentation
    }
    
    func testJSONTimestamp() throws {
        let identifiers = [
            "TestVC": [
                GeneratedIdentifier(ownerType: "TestVC", propertyName: "label")
            ]
        ]
        
        let outputPath = (tempDirectory as NSString).appendingPathComponent("timestamp.json")
        
        try exporter.exportJSON(identifiersByType: identifiers, to: outputPath)
        
        let data = try Data(contentsOf: URL(fileURLWithPath: outputPath))
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        let timestamp = json?["generated_at"] as? String
        XCTAssertNotNil(timestamp)
        
        // Verify it's a valid ISO8601 timestamp
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: timestamp!)
        XCTAssertNotNil(date)
    }
}

