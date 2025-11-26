//
//  main.swift
//  NSAutoAXGenerator
//
//  Main entry point for the NSAutoAXKit generator tool.
//

import Foundation

/// Main function that orchestrates the generation process.
func main() {
    let arguments = Array(CommandLine.arguments.dropFirst())
    
    // Parse arguments
    let configuration: GeneratorConfiguration
    do {
        configuration = try ArgumentParser.parse(arguments)
    } catch let error as GeneratorError {
        printError(error.description)
        exit(2)
    } catch {
        printError("Failed to parse arguments: \(error)")
        exit(2)
    }
    
    if configuration.verbose {
        print("[NSAutoAXGenerator] Starting generation process...")
        print("[NSAutoAXGenerator] Input paths: \(configuration.inputPaths)")
        print("[NSAutoAXGenerator] Output directory: \(configuration.outputDirectory)")
    }
    
    // Discover Swift files
    let swiftFiles = SourceParser.discoverSwiftFiles(in: configuration.inputPaths)
    
    if configuration.verbose {
        print("[NSAutoAXGenerator] Found \(swiftFiles.count) Swift file(s) to process")
    }
    
    guard !swiftFiles.isEmpty else {
        printError("No Swift files found in input paths")
        exit(1)
    }
    
    // Parse all files
    let parser = SourceParser(verbose: configuration.verbose)
    var allTypeDefinitions: [TypeDefinition] = []
    var warnings: [String] = []
    var errors: [String] = []
    
    for filePath in swiftFiles {
        do {
            let types = try parser.parse(file: filePath)
            allTypeDefinitions.append(contentsOf: types)
        } catch let error as GeneratorError {
            let errorMsg = error.description
            errors.append(errorMsg)
            printError(errorMsg)
            
            if configuration.strictMode {
                exit(1)
            }
        } catch {
            let errorMsg = "Unexpected error parsing \(filePath): \(error)"
            errors.append(errorMsg)
            printError(errorMsg)
            
            if configuration.strictMode {
                exit(1)
            }
        }
    }
    
    if configuration.verbose {
        print("[NSAutoAXGenerator] Parsed \(allTypeDefinitions.count) type(s) with @IBOutlet properties")
    }
    
    guard !allTypeDefinitions.isEmpty else {
        printWarning("No types with @IBOutlet properties found")
        
        // Still write empty JSON if requested
        if let jsonPath = configuration.jsonOutputPath {
            do {
                let exporter = JSONExporter(verbose: configuration.verbose)
                try exporter.exportJSON(identifiersByType: [:], to: jsonPath)
            } catch {
                printError("Failed to export JSON: \(error)")
            }
        }
        
        exit(0)
    }
    
    // Generate identifiers
    let generator = IdentifierGenerator(verbose: configuration.verbose)
    let identifiersByType = generator.generateIdentifiers(for: allTypeDefinitions)
    
    // Validate identifiers
    let validationWarnings = generator.validateIdentifiers(identifiersByType)
    warnings.append(contentsOf: validationWarnings)
    
    for warning in validationWarnings {
        printWarning(warning)
    }
    
    // Generate Swift files
    let emitter = CodeEmitter(verbose: configuration.verbose)
    let filesGenerated: Int
    
    do {
        filesGenerated = try emitter.generateFiles(
            identifiersByType: identifiersByType,
            typeDefinitions: allTypeDefinitions,
            outputDirectory: configuration.outputDirectory
        )
    } catch let error as GeneratorError {
        printError(error.description)
        exit(1)
    } catch {
        printError("Unexpected error generating files: \(error)")
        exit(1)
    }
    
    // Export JSON if requested
    if let jsonPath = configuration.jsonOutputPath {
        do {
            let exporter = JSONExporter(verbose: configuration.verbose)
            try exporter.exportJSON(identifiersByType: identifiersByType, to: jsonPath)
        } catch let error as GeneratorError {
            printError(error.description)
            exit(1)
        } catch {
            printError("Unexpected error exporting JSON: \(error)")
            exit(1)
        }
    }
    
    // Print summary
    let totalIdentifiers = identifiersByType.values.reduce(0) { $0 + $1.count }
    
    if configuration.verbose || true {
        print("\n[NSAutoAXGenerator] ✓ Generation completed successfully")
        print("[NSAutoAXGenerator]   Types processed: \(allTypeDefinitions.count)")
        print("[NSAutoAXGenerator]   Identifiers generated: \(totalIdentifiers)")
        print("[NSAutoAXGenerator]   Files generated: \(filesGenerated)")
        
        if !warnings.isEmpty {
            print("[NSAutoAXGenerator]   Warnings: \(warnings.count)")
        }
    }
    
    exit(0)
}

/// Prints an error message to stderr.
func printError(_ message: String) {
    fputs("ERROR: \(message)\n", stderr)
}

/// Prints a warning message to stderr.
func printWarning(_ message: String) {
    fputs("WARNING: \(message)\n", stderr)
}

// Run the main function
main()

