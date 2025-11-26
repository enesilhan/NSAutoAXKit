//
//  ArgumentParser.swift
//  NSAutoAXGenerator
//
//  Parses command-line arguments for the generator tool.
//

import Foundation

/// Parses command-line arguments and creates a generator configuration.
struct ArgumentParser {
    
    /// Parses command-line arguments and returns a configuration.
    ///
    /// - Parameter arguments: Array of command-line arguments (excluding program name)
    /// - Returns: Generator configuration
    /// - Throws: GeneratorError.invalidArguments if parsing fails
    static func parse(_ arguments: [String]) throws -> GeneratorConfiguration {
        var inputPaths: [String] = []
        var outputDirectory: String?
        var jsonOutputPath: String?
        var verbose = false
        var strictMode = false
        
        var index = 0
        while index < arguments.count {
            let arg = arguments[index]
            
            switch arg {
            case "--input-paths":
                // Collect all paths until next flag
                index += 1
                while index < arguments.count && !arguments[index].hasPrefix("--") {
                    inputPaths.append(arguments[index])
                    index += 1
                }
                continue
                
            case "--output-dir":
                guard index + 1 < arguments.count else {
                    throw GeneratorError.invalidArguments("--output-dir requires a value")
                }
                outputDirectory = arguments[index + 1]
                index += 2
                
            case "--json-output":
                guard index + 1 < arguments.count else {
                    throw GeneratorError.invalidArguments("--json-output requires a value")
                }
                jsonOutputPath = arguments[index + 1]
                index += 2
                
            case "--verbose", "-v":
                verbose = true
                index += 1
                
            case "--strict":
                strictMode = true
                index += 1
                
            case "--help", "-h":
                printUsage()
                throw GeneratorError.invalidArguments("Help requested")
                
            default:
                throw GeneratorError.invalidArguments("Unknown argument: \(arg)")
            }
        }
        
        // Validate required arguments
        guard !inputPaths.isEmpty else {
            throw GeneratorError.invalidArguments("--input-paths is required")
        }
        
        guard let outputDir = outputDirectory else {
            throw GeneratorError.invalidArguments("--output-dir is required")
        }
        
        return GeneratorConfiguration(
            inputPaths: inputPaths,
            outputDirectory: outputDir,
            jsonOutputPath: jsonOutputPath,
            verbose: verbose,
            strictMode: strictMode
        )
    }
    
    /// Prints usage information to stdout.
    static func printUsage() {
        let usage = """
        NSAutoAXKit Generator v1.0.0
        
        Automatically generates accessibility identifiers for UIKit @IBOutlet properties.
        
        USAGE:
            autoax-generator --input-paths <path1> [path2...] --output-dir <dir> [options]
        
        REQUIRED:
            --input-paths <paths>    One or more Swift source files or directories to scan
            --output-dir <dir>       Directory where generated files will be written
        
        OPTIONS:
            --json-output <path>     Export identifiers to JSON file (optional)
            --verbose, -v            Enable verbose logging
            --strict                 Fail on parse errors (default: warnings only)
            --help, -h               Show this help message
        
        EXIT CODES:
            0    Success
            1    Parsing error
            2    Invalid arguments
        
        EXAMPLES:
            # Scan a single file
            autoax-generator --input-paths Sources/MyViewController.swift --output-dir .build/autoax
        
            # Scan multiple directories
            autoax-generator --input-paths Sources/ Views/ --output-dir .build/autoax
        
            # With JSON export
            autoax-generator --input-paths Sources/ --output-dir .build/autoax --json-output identifiers.json
        
        GENERATED FILES:
            For each type with @IBOutlet properties, generates:
                <TypeName>+AutoAX.swift
        
            Each file contains an extension with an applyAutoAX() method.
        
        For more information, visit: https://github.com/yourorg/NSAutoAXKit
        """
        
        print(usage)
    }
}

