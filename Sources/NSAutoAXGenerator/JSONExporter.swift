//
//  JSONExporter.swift
//  NSAutoAXGenerator
//
//  Exports accessibility identifiers to JSON format for QA and testing.
//

import Foundation

/// Exports generated identifiers to JSON format.
struct JSONExporter {
    
    private let verbose: Bool
    private let version = "1.0.0"
    
    init(verbose: Bool = false) {
        self.verbose = verbose
    }
    
    /// Exports identifiers to a JSON file.
    ///
    /// - Parameters:
    ///   - identifiersByType: Dictionary mapping type names to identifiers
    ///   - outputPath: Path where JSON file will be written
    /// - Throws: GeneratorError if export fails
    func exportJSON(
        identifiersByType: [String: [GeneratedIdentifier]],
        to outputPath: String
    ) throws {
        log("Exporting JSON to: \(outputPath)")
        
        // Build JSON structure
        let timestamp = ISO8601DateFormatter().string(from: Date())
        
        var identifiersDict: [String: [String: String]] = [:]
        
        for (typeName, identifiers) in identifiersByType {
            var typeIdentifiers: [String: String] = [:]
            
            for identifier in identifiers {
                typeIdentifiers[identifier.propertyName] = identifier.identifier
            }
            
            identifiersDict[typeName] = typeIdentifiers
        }
        
        let jsonObject: [String: Any] = [
            "generated_at": timestamp,
            "generator_version": version,
            "identifiers": identifiersDict
        ]
        
        // Serialize to JSON
        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted, .sortedKeys]
            )
            
            try jsonData.write(to: URL(fileURLWithPath: outputPath))
            
            log("Successfully exported \(identifiersByType.count) type(s) to JSON")
        } catch {
            throw GeneratorError.jsonExportError(error.localizedDescription)
        }
    }
    
    private func log(_ message: String) {
        guard verbose else { return }
        print("[JSONExporter] \(message)")
    }
}

/// Codable structure for JSON export (alternative approach for type safety)
struct IdentifierExport: Codable {
    let generatedAt: String
    let generatorVersion: String
    let identifiers: [String: [String: String]]
    
    enum CodingKeys: String, CodingKey {
        case generatedAt = "generated_at"
        case generatorVersion = "generator_version"
        case identifiers
    }
}

