//
//  SourceParser.swift
//  NSAutoAXGenerator
//
//  Parses Swift source files using SwiftSyntax to extract type definitions
//  and @IBOutlet properties.
//

import Foundation
import SwiftSyntax
import SwiftParser

/// Parses Swift source files to extract type definitions with IBOutlet properties.
struct SourceParser {
    
    private let verbose: Bool
    
    init(verbose: Bool = false) {
        self.verbose = verbose
    }
    
    /// Parses a Swift source file and extracts all relevant type definitions.
    ///
    /// - Parameter filePath: Path to the Swift source file
    /// - Returns: Array of type definitions found in the file
    /// - Throws: GeneratorError if file cannot be read or parsed
    func parse(file filePath: String) throws -> [TypeDefinition] {
        log("Parsing file: \(filePath)")
        
        // Read file contents
        guard let fileContents = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            throw GeneratorError.fileNotFound(filePath)
        }
        
        // Parse with SwiftSyntax
        let sourceFile = Parser.parse(source: fileContents)
        
        // Visit the syntax tree to extract type definitions
        let visitor = TypeDefinitionVisitor(filePath: filePath, verbose: verbose)
        visitor.walk(sourceFile)
        
        let types = visitor.typeDefinitions
        log("Found \(types.count) type(s) with @IBOutlet properties in \(filePath)")
        
        return types
    }
    
    /// Discovers all Swift files in the given paths (files or directories).
    ///
    /// - Parameter paths: Array of file or directory paths
    /// - Returns: Array of Swift file paths
    static func discoverSwiftFiles(in paths: [String]) -> [String] {
        var swiftFiles: [String] = []
        let fileManager = FileManager.default
        
        for path in paths {
            var isDirectory: ObjCBool = false
            guard fileManager.fileExists(atPath: path, isDirectory: &isDirectory) else {
                continue
            }
            
            if isDirectory.boolValue {
                // Recursively find .swift files
                if let enumerator = fileManager.enumerator(atPath: path) {
                    for case let file as String in enumerator {
                        if file.hasSuffix(".swift") && shouldIncludeFile(file) {
                            let fullPath = (path as NSString).appendingPathComponent(file)
                            swiftFiles.append(fullPath)
                        }
                    }
                }
            } else if path.hasSuffix(".swift") {
                swiftFiles.append(path)
            }
        }
        
        return swiftFiles
    }
    
    /// Determines if a file should be included in the scan.
    ///
    /// - Parameter path: Relative file path
    /// - Returns: True if file should be included
    private static func shouldIncludeFile(_ path: String) -> Bool {
        // Exclude certain paths
        let excludePatterns = [
            "Tests/",
            "Generated/",
            ".build/",
            ".generated",
            "+AutoAX.swift"
        ]
        
        for pattern in excludePatterns {
            if path.contains(pattern) {
                return false
            }
        }
        
        return true
    }
    
    private func log(_ message: String) {
        guard verbose else { return }
        print("[SourceParser] \(message)")
    }
}

/// Syntax visitor that extracts type definitions with @IBOutlet properties.
private class TypeDefinitionVisitor: SyntaxVisitor {
    let filePath: String
    let verbose: Bool
    var typeDefinitions: [TypeDefinition] = []
    
    init(filePath: String, verbose: Bool) {
        self.filePath = filePath
        self.verbose = verbose
        super.init(viewMode: .sourceAccurate)
    }
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        processTypeDeclaration(
            name: node.name.text,
            inheritanceClause: node.inheritanceClause,
            memberBlock: node.memberBlock
        )
        return .visitChildren
    }
    
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        processTypeDeclaration(
            name: node.name.text,
            inheritanceClause: node.inheritanceClause,
            memberBlock: node.memberBlock
        )
        return .visitChildren
    }
    
    private func processTypeDeclaration(
        name: String,
        inheritanceClause: InheritanceClauseSyntax?,
        memberBlock: MemberBlockSyntax
    ) {
        // Extract inherited types
        let inheritedTypes = extractInheritedTypes(from: inheritanceClause)
        
        // Extract @IBOutlet properties
        let outlets = extractOutlets(from: memberBlock)
        
        // Only create type definition if it has outlets
        guard !outlets.isEmpty else {
            return
        }
        
        let typeDef = TypeDefinition(
            name: name,
            sourceFilePath: filePath,
            outlets: outlets,
            inheritedTypes: inheritedTypes
        )
        
        log("Found type: \(name) with \(outlets.count) outlet(s)")
        typeDefinitions.append(typeDef)
    }
    
    private func extractInheritedTypes(from clause: InheritanceClauseSyntax?) -> [String] {
        guard let clause = clause else {
            return []
        }
        
        return clause.inheritedTypes.map { inherited in
            inherited.type.trimmedDescription
        }
    }
    
    private func extractOutlets(from memberBlock: MemberBlockSyntax) -> [OutletProperty] {
        var outlets: [OutletProperty] = []
        
        for member in memberBlock.members {
            guard let variable = member.decl.as(VariableDeclSyntax.self) else {
                continue
            }
            
            // Check if this variable has @IBOutlet attribute
            guard hasIBOutletAttribute(variable) else {
                continue
            }
            
            // Extract property details
            for binding in variable.bindings {
                guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
                    continue
                }
                
                let propertyName = pattern.identifier.text
                
                // Extract type annotation
                guard let typeAnnotation = binding.typeAnnotation else {
                    log("Warning: No type annotation for property \(propertyName)")
                    continue
                }
                
                let typeName = typeAnnotation.type.trimmedDescription
                let isOptional = typeName.hasSuffix("?") || typeName.hasSuffix("!")
                
                let outlet = OutletProperty(
                    name: propertyName,
                    typeName: typeName,
                    isOptional: isOptional
                )
                
                outlets.append(outlet)
                log("  Found outlet: \(propertyName): \(typeName)")
            }
        }
        
        return outlets
    }
    
    private func hasIBOutletAttribute(_ variable: VariableDeclSyntax) -> Bool {
        for attribute in variable.attributes {
            if let attr = attribute.as(AttributeSyntax.self) {
                let attributeName = attr.attributeName.trimmedDescription
                if attributeName == "IBOutlet" {
                    return true
                }
            }
        }
        return false
    }
    
    private func log(_ message: String) {
        guard verbose else { return }
        print("[TypeDefinitionVisitor] \(message)")
    }
}

