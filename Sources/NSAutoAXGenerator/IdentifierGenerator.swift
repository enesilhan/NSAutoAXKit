//
//  IdentifierGenerator.swift
//  NSAutoAXGenerator
//
//  Generates accessibility identifiers from type definitions.
//

import Foundation

/// Generates accessibility identifiers for types and their outlets.
struct IdentifierGenerator {
    
    private let verbose: Bool
    
    init(verbose: Bool = false) {
        self.verbose = verbose
    }
    
    /// Generates identifiers for a collection of type definitions.
    ///
    /// - Parameter types: Array of type definitions to process
    /// - Returns: Dictionary mapping type names to their outlet identifiers
    func generateIdentifiers(for types: [TypeDefinition]) -> [String: [GeneratedIdentifier]] {
        var result: [String: [GeneratedIdentifier]] = [:]
        
        for typeDef in types {
            // Only generate for UIKit types
            guard typeDef.isUIKitType else {
                log("Skipping non-UIKit type: \(typeDef.name)")
                continue
            }
            
            var identifiers: [GeneratedIdentifier] = []
            var propertyNameCounts: [String: Int] = [:]
            
            for outlet in typeDef.outlets {
                // Only generate for UIKit controls
                guard outlet.isUIKitControl else {
                    log("Skipping non-UIKit outlet: \(typeDef.name).\(outlet.name) (\(outlet.typeName))")
                    continue
                }
                
                // Handle duplicate property names by appending index
                let propertyName: String
                if let count = propertyNameCounts[outlet.name] {
                    propertyNameCounts[outlet.name] = count + 1
                    propertyName = "\(outlet.name)_\(count)"
                    log("Warning: Duplicate property name '\(outlet.name)' in \(typeDef.name), using '\(propertyName)'")
                } else {
                    propertyNameCounts[outlet.name] = 1
                    propertyName = outlet.name
                }
                
                let identifier = GeneratedIdentifier(
                    ownerType: typeDef.name,
                    propertyName: propertyName
                )
                
                identifiers.append(identifier)
            }
            
            if !identifiers.isEmpty {
                result[typeDef.name] = identifiers
                log("Generated \(identifiers.count) identifier(s) for \(typeDef.name)")
            }
        }
        
        return result
    }
    
    /// Validates that generated identifiers are unique within their scope.
    ///
    /// - Parameter identifiersByType: Dictionary of identifiers grouped by type
    /// - Returns: Array of validation warnings
    func validateIdentifiers(_ identifiersByType: [String: [GeneratedIdentifier]]) -> [String] {
        var warnings: [String] = []
        
        for (typeName, identifiers) in identifiersByType {
            let identifierStrings = identifiers.map { $0.identifier }
            let uniqueIdentifiers = Set(identifierStrings)
            
            if identifierStrings.count != uniqueIdentifiers.count {
                warnings.append("Type \(typeName) has duplicate identifiers (should not happen)")
            }
        }
        
        return warnings
    }
    
    private func log(_ message: String) {
        guard verbose else { return }
        print("[IdentifierGenerator] \(message)")
    }
}

