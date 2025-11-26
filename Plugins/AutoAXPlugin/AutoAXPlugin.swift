//
//  AutoAXPlugin.swift
//  NSAutoAXKit
//
//  Build tool plugin that automatically generates accessibility identifiers
//  during the build process.
//

import PackagePlugin
import Foundation

/// Build tool plugin that runs the NSAutoAXGenerator during compilation.
///
/// This plugin automatically discovers Swift source files in the target,
/// runs the generator tool, and registers the generated files for compilation.
@main
struct AutoAXPlugin: BuildToolPlugin {
    
    /// Creates build commands for the plugin.
    ///
    /// This method is called by SPM during the build process. It discovers source files,
    /// invokes the generator tool, and registers generated outputs.
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) async throws -> [Command] {
        
        // Only process source module targets
        guard let sourceTarget = target as? SourceModuleTarget else {
            return []
        }
        
        // Get the generator tool
        let generatorTool = try context.tool(named: "NSAutoAXGenerator")
        
        // Discover Swift source files
        let swiftFiles = sourceTarget.sourceFiles(withSuffix: ".swift")
            .filter { shouldIncludeFile($0.path) }
            .map { $0.path }
        
        // If no Swift files, skip generation
        guard !swiftFiles.isEmpty else {
            return []
        }
        
        // Create output directory in plugin work directory
        let outputDirectory = context.pluginWorkDirectory.appending("Generated")
        
        // Build generator arguments
        var arguments: [String] = [
            "--input-paths"
        ]
        
        // Add all Swift file paths
        arguments.append(contentsOf: swiftFiles.map { $0.string })
        
        arguments.append(contentsOf: [
            "--output-dir",
            outputDirectory.string
        ])
        
        // Optional: Export JSON to plugin work directory
        let jsonOutputPath = context.pluginWorkDirectory.appending("AutoAXIdentifiers.json")
        arguments.append(contentsOf: [
            "--json-output",
            jsonOutputPath.string
        ])
        
        // Enable verbose logging in debug builds
        #if DEBUG
        arguments.append("--verbose")
        #endif
        
        // Create the build command
        let command = Command.buildCommand(
            displayName: "Generating accessibility identifiers for \(target.name)",
            executable: generatorTool.path,
            arguments: arguments,
            inputFiles: swiftFiles,
            outputFiles: [
                // Register the output directory
                outputDirectory
            ]
        )
        
        return [command]
    }
    
    /// Determines if a file should be included in generation.
    ///
    /// - Parameter path: The file path to check
    /// - Returns: True if the file should be processed
    private func shouldIncludeFile(_ path: Path) -> Bool {
        let pathString = path.string
        
        // Exclude patterns
        let excludePatterns = [
            "Tests/",
            "Test.swift",
            "Generated/",
            ".generated",
            "+AutoAX.swift",
            ".build/"
        ]
        
        for pattern in excludePatterns {
            if pathString.contains(pattern) {
                return false
            }
        }
        
        return true
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

/// Xcode build tool plugin extension for IDE integration.
extension AutoAXPlugin: XcodeBuildToolPlugin {
    
    /// Creates build commands for Xcode projects.
    func createBuildCommands(
        context: XcodePluginContext,
        target: XcodeTarget
    ) throws -> [Command] {
        
        // Get the generator tool
        let generatorTool = try context.tool(named: "NSAutoAXGenerator")
        
        // Get input files from Xcode target
        let swiftFiles = target.inputFiles
            .filter { $0.path.extension == "swift" }
            .filter { shouldIncludeFile($0.path) }
            .map { $0.path }
        
        guard !swiftFiles.isEmpty else {
            return []
        }
        
        // Create output directory
        let outputDirectory = context.pluginWorkDirectory.appending("Generated")
        
        // Build arguments
        var arguments: [String] = [
            "--input-paths"
        ]
        
        arguments.append(contentsOf: swiftFiles.map { $0.string })
        
        arguments.append(contentsOf: [
            "--output-dir",
            outputDirectory.string
        ])
        
        // Export JSON
        let jsonOutputPath = context.pluginWorkDirectory.appending("AutoAXIdentifiers.json")
        arguments.append(contentsOf: [
            "--json-output",
            jsonOutputPath.string
        ])
        
        // Create command
        let command = Command.buildCommand(
            displayName: "Generating accessibility identifiers for \(target.displayName)",
            executable: generatorTool.path,
            arguments: arguments,
            inputFiles: swiftFiles,
            outputFiles: [
                outputDirectory
            ]
        )
        
        return [command]
    }
}
#endif

