//
//  Models.swift
//  NSAutoAXGenerator
//
//  Data models used throughout the generator tool.
//

import Foundation

/// Represents a Swift type (class/struct) that contains IBOutlet properties.
struct TypeDefinition {
    /// The name of the type (e.g., "LoginViewController")
    let name: String
    
    /// The file path where this type is defined
    let sourceFilePath: String
    
    /// The list of IBOutlet properties in this type
    let outlets: [OutletProperty]
    
    /// The inheritance chain (e.g., ["UIViewController", "BaseViewController"])
    let inheritedTypes: [String]
    
    /// Returns true if this type inherits from UIKit base types we support
    var isUIKitType: Bool {
        let supportedTypes = [
            "UIViewController",
            "UIView",
            "UITableViewCell",
            "UICollectionViewCell"
        ]
        
        return inheritedTypes.contains { inherited in
            supportedTypes.contains(inherited)
        }
    }
}

/// Represents a single @IBOutlet property.
struct OutletProperty {
    /// The property name (e.g., "loginButton")
    let name: String
    
    /// The type name (e.g., "UIButton")
    let typeName: String
    
    /// Whether this is an optional type
    let isOptional: Bool
    
    /// Returns true if this is a UIKit control type
    var isUIKitControl: Bool {
        let uikitTypes = [
            "UILabel",
            "UIButton",
            "UITextField",
            "UITextView",
            "UIImageView",
            "UISwitch",
            "UISlider",
            "UISegmentedControl",
            "UIPickerView",
            "UIDatePicker",
            "UIProgressView",
            "UIActivityIndicatorView",
            "UIScrollView",
            "UITableView",
            "UICollectionView",
            "UIStackView",
            "UIView"
        ]
        
        // Remove optional suffix if present for comparison
        let baseType = typeName.replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "!", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return uikitTypes.contains(baseType)
    }
}

/// Represents a generated accessibility identifier.
struct GeneratedIdentifier {
    /// The owner type name
    let ownerType: String
    
    /// The property name
    let propertyName: String
    
    /// The full identifier string (e.g., "LoginViewController.loginButton")
    var identifier: String {
        return "\(ownerType).\(propertyName)"
    }
}

/// Configuration for the generator tool.
struct GeneratorConfiguration {
    /// Input paths to scan (files or directories)
    let inputPaths: [String]
    
    /// Output directory for generated Swift files
    let outputDirectory: String
    
    /// Optional path for JSON export
    let jsonOutputPath: String?
    
    /// Whether to enable verbose logging
    let verbose: Bool
    
    /// Whether to fail on errors (strict mode)
    let strictMode: Bool
    
    init(
        inputPaths: [String],
        outputDirectory: String,
        jsonOutputPath: String? = nil,
        verbose: Bool = false,
        strictMode: Bool = false
    ) {
        self.inputPaths = inputPaths
        self.outputDirectory = outputDirectory
        self.jsonOutputPath = jsonOutputPath
        self.verbose = verbose
        self.strictMode = strictMode
    }
}

/// Result of the generation process.
struct GenerationResult {
    /// Number of types processed
    let typesProcessed: Int
    
    /// Number of identifiers generated
    let identifiersGenerated: Int
    
    /// Number of files generated
    let filesGenerated: Int
    
    /// Warnings encountered during generation
    let warnings: [String]
    
    /// Errors encountered during generation
    let errors: [String]
    
    /// Whether the generation was successful
    var isSuccess: Bool {
        return errors.isEmpty
    }
}

/// Error types that can occur during generation.
enum GeneratorError: Error, CustomStringConvertible {
    case invalidArguments(String)
    case fileNotFound(String)
    case parseError(String, file: String)
    case outputDirectoryCreationFailed(String)
    case fileWriteError(String, path: String)
    case jsonExportError(String)
    
    var description: String {
        switch self {
        case .invalidArguments(let message):
            return "Invalid arguments: \(message)"
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .parseError(let message, let file):
            return "Parse error in \(file): \(message)"
        case .outputDirectoryCreationFailed(let path):
            return "Failed to create output directory: \(path)"
        case .fileWriteError(let message, let path):
            return "Failed to write file \(path): \(message)"
        case .jsonExportError(let message):
            return "JSON export failed: \(message)"
        }
    }
}

