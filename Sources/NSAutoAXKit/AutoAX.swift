//
//  AutoAX.swift
//  NSAutoAXKit
//
//  Lightweight runtime utilities for applying auto-generated accessibility identifiers.
//

#if canImport(UIKit)
import UIKit
#else
#error("NSAutoAXKit requires UIKit. This package is only compatible with iOS and iPadOS.")
#endif

/// Main entry point for NSAutoAXKit runtime functionality.
///
/// Provides utility methods for manually applying accessibility identifiers
/// to views and view controllers.
///
/// ## Usage
///
/// ```swift
/// // Apply identifiers to a view controller
/// AutoAX.apply(to: myViewController)
///
/// // Apply identifiers to a view
/// AutoAX.apply(to: myView)
/// ```
public struct AutoAX {
    
    // Prevent instantiation
    private init() {}
    
    /// Applies auto-generated accessibility identifiers to a view controller.
    ///
    /// This method checks if the view controller has a generated `applyAutoAX()` method
    /// via extension and calls it if available. Safe to call even if no extension exists.
    ///
    /// - Parameter viewController: The view controller to apply identifiers to.
    public static func apply(to viewController: UIViewController) {
        viewController.applyAutoAXIfAvailable()
    }
    
    /// Applies auto-generated accessibility identifiers to a view.
    ///
    /// This method checks if the view has a generated `applyAutoAX()` method
    /// via extension and calls it if available. Safe to call even if no extension exists.
    ///
    /// - Parameter view: The view to apply identifiers to.
    public static func apply(to view: UIView) {
        view.applyAutoAXIfAvailable()
    }
    
    /// Returns the current version of NSAutoAXKit.
    ///
    /// This can be useful for debugging and logging which version of the framework
    /// is being used at runtime.
    ///
    /// - Returns: Version string in semantic versioning format (e.g., "1.0.0").
    public static var version: String {
        return "1.0.0"
    }
    
    /// Enables verbose logging for debugging.
    ///
    /// When enabled, NSAutoAXKit will log information about which identifiers
    /// are being applied. Useful during development and debugging.
    ///
    /// - Note: Logging is disabled by default for performance.
    public static var loggingEnabled: Bool = false
    
    /// Internal helper for logging when enabled.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - type: The type name for context.
    internal static func log(_ message: String, type: String? = nil) {
        guard loggingEnabled else { return }
        
        let prefix = "[NSAutoAXKit]"
        if let type = type {
            print("\(prefix) [\(type)] \(message)")
        } else {
            print("\(prefix) \(message)")
        }
    }
}

