# NSAutoAXKit

**Automatic, consistent accessibility identifiers for reliable UI testing — with minimal developer effort and maximum safety.**

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2013.0%2B%20%7C%20macOS%2013.0%2B-lightgrey.svg)](https://developer.apple.com)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## Overview

Manually maintaining accessibility identifiers is tedious, error-prone, and scales poorly:

- Identifiers get outdated when properties are renamed
- New outlets are forgotten, breaking UI tests
- Inconsistent naming conventions across teams
- Manual JSON exports for QA are time-consuming

**NSAutoAXKit automates all of this.**

- Deterministic identifiers: `TypeName.propertyName`
- Regenerated automatically on every build
- Works seamlessly with UIKit `@IBOutlet` properties
- Optional JSON export for XCUITest integration
- Zero runtime overhead, safe by design

---

## Features

### For Developers
- **Zero Configuration**: Add the plugin, call one method, done
- **Type-Safe**: Generated code compiles with your project
- **Refactor-Friendly**: Rename a property? Identifier updates automatically
- **SwiftLint Compatible**: Generated files marked with `// swiftlint:disable all`

### For QA & Automation Engineers
- **Consistent Naming**: All identifiers follow `TypeName.propertyName` format
- **JSON Export**: Programmatic access to all identifiers
- **Comprehensive Coverage**: All `@IBOutlet` properties automatically included

### For Teams
- **Scalable**: Works on codebases of any size
- **CI/CD Ready**: Deterministic generation, no surprises
- **No Maintenance**: Set it and forget it

---

## Installation

Add NSAutoAXKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourorg/NSAutoAXKit", from: "1.0.0")
]
```

Add to your app target:

```swift
targets: [
    .target(
        name: "YourApp",
        dependencies: ["NSAutoAXKit"],
        plugins: ["AutoAXPlugin"]
    )
]
```

---

## Integration

### Option 1: Base View Controller (Recommended)

Create a base class that all your view controllers inherit from:

```swift
import NSAutoAXKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        applyAutoAXIfAvailable()
    }
}
```

Now all subclasses automatically get accessibility identifiers:

```swift
class LoginViewController: BaseViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // No additional code needed
    // Identifiers are automatically applied in viewDidLoad via base class
}
```

### Option 2: Manual Application

Call `applyAutoAX()` explicitly in each view controller:

```swift
import NSAutoAXKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyAutoAX() // Generated method
    }
}
```

### Option 3: Utility Method

Use the static utility method:

```swift
import NSAutoAXKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AutoAX.apply(to: self)
    }
}
```

---

## How It Works

### Build Time

1. **Discovery**: The build plugin scans your Swift source files
2. **Parsing**: SwiftSyntax extracts all `@IBOutlet` properties from UIKit types
3. **Generation**: Creates extension files with `applyAutoAX()` methods:

```swift
// LoginViewController+AutoAX.swift (generated)

extension LoginViewController {
    func applyAutoAX() {
        emailField?.accessibilityIdentifier = "LoginViewController.emailField"
        passwordField?.accessibilityIdentifier = "LoginViewController.passwordField"
        loginButton?.accessibilityIdentifier = "LoginViewController.loginButton"
    }
}
```

4. **Compilation**: Generated files are automatically compiled with your project

### Runtime

Call `applyAutoAX()` or `applyAutoAXIfAvailable()` to apply the identifiers.

---

## Identifier Format

NSAutoAXKit generates deterministic identifiers using this format:

```
<OwnerType>.<propertyName>
```

### Examples

| Property Declaration | Generated Identifier |
|---------------------|---------------------|
| `@IBOutlet weak var loginButton: UIButton!` | `LoginViewController.loginButton` |
| `@IBOutlet weak var titleLabel: UILabel!` | `HeaderView.titleLabel` |
| `@IBOutlet weak var imageView: UIImageView?` | `ProfileCell.imageView` |

### Duplicate Property Names

If a type has duplicate property names (rare but possible), NSAutoAXKit appends an index:

```swift
@IBOutlet weak var button: UIButton!
@IBOutlet weak var button: UIButton! // button_1
@IBOutlet weak var button: UIButton! // button_2
```

---

## JSON Export for QA

Enable JSON export to get a machine-readable list of all identifiers.

The plugin automatically exports `AutoAXIdentifiers.json` to the build directory:

```json
{
  "generated_at": "2025-11-26T10:30:00Z",
  "generator_version": "1.0.0",
  "identifiers": {
    "LoginViewController": {
      "emailField": "LoginViewController.emailField",
      "passwordField": "LoginViewController.passwordField",
      "loginButton": "LoginViewController.loginButton"
    },
    "ProfileView": {
      "nameLabel": "ProfileView.nameLabel",
      "avatarImageView": "ProfileView.avatarImageView"
    }
  }
}
```

### Using in XCUITest

```swift
struct AutoAXIdentifiers: Codable {
    let generatedAt: String
    let generatorVersion: String
    let identifiers: [String: [String: String]]
    
    enum CodingKeys: String, CodingKey {
        case generatedAt = "generated_at"
        case generatorVersion = "generator_version"
        case identifiers
    }
}

// In your UI test:
let jsonURL = Bundle(for: type(of: self)).url(forResource: "AutoAXIdentifiers", withExtension: "json")!
let data = try Data(contentsOf: jsonURL)
let ids = try JSONDecoder().decode(AutoAXIdentifiers.self, from: data)

let loginButtonID = ids.identifiers["LoginViewController"]?["loginButton"]!
app.buttons[loginButtonID].tap()
```

---

## Supported Types

### UIKit Classes

NSAutoAXKit automatically processes these types:

- `UIViewController` (and subclasses)
- `UIView` (and subclasses)
- `UITableViewCell` (and subclasses)
- `UICollectionViewCell` (and subclasses)

### UIKit Controls

These outlet types are automatically included:

- `UILabel`, `UIButton`, `UITextField`, `UITextView`
- `UIImageView`, `UISwitch`, `UISlider`, `UISegmentedControl`
- `UIPickerView`, `UIDatePicker`, `UIProgressView`, `UIActivityIndicatorView`
- `UIScrollView`, `UITableView`, `UICollectionView`, `UIStackView`
- Generic `UIView` (catches custom subclasses)

### Current Limitations

- SwiftUI views (planned for Phase 2)
- Programmatic views (not declared as `@IBOutlet`)
- Custom non-UIKit types

---

## Tooling Integration

### SwiftLint

Generated files automatically include:

```swift
// swiftlint:disable all
```

Recommended `.swiftlint.yml` exclusion:

```yaml
excluded:
  - .build
  - DerivedData
  - .autoax-generated
  - "**/Generated"
```

### Periphery

Generated extensions might appear unused. Exclude the build directory:

```bash
periphery scan --exclude .build
```

### Git

**Option 1: Gitignore Generated Files (Recommended)**

```gitignore
# .gitignore
*+AutoAX.swift
AutoAXIdentifiers.json
```

**Option 2: Commit Generated Files**

Benefits: Faster CI builds, stable diffs  
Downside: Larger PRs

Choose based on your team's workflow.

---

## Testing

### Running Tests

```bash
swift test
```

### Test Coverage

- Unit tests for source parser
- Unit tests for identifier generation logic
- Unit tests for code emission
- Unit tests for JSON export
- Integration tests for runtime behavior

---

## CI/CD Integration

### GitHub Actions

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-13
    steps:
      - uses: actions/checkout@v3
      
      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_15.0.app
      
      - name: Build
        run: swift build
      
      - name: Run Tests
        run: swift test
```

### Xcode Cloud

NSAutoAXKit works seamlessly with Xcode Cloud. The build plugin runs automatically during the build phase.

---

## Troubleshooting

### "No identifiers generated"

**Cause**: No `@IBOutlet` properties found in scanned files.

**Solution**: Verify your source files have `@IBOutlet` properties in UIKit types.

### "Generator tool not found"

**Cause**: Plugin dependency not resolved.

**Solution**: 
```bash
swift package resolve
swift build
```

### "SwiftSyntax version mismatch"

**Cause**: Incompatible Swift toolchain version.

**Solution**: Update to Swift 5.9+ / Xcode 15.0+

```bash
swift --version  # Should be 5.9 or higher
```

### Identifiers not applied at runtime

**Cause**: `applyAutoAX()` or `applyAutoAXIfAvailable()` not called.

**Solution**: Verify you're calling the method in `viewDidLoad()` or using a base class.

### Build is slow

**Cause**: Full regeneration on every build.

**Solution**: This is expected behavior for MVP. Incremental generation is planned for Phase 2.

---

## Roadmap

### Phase 1 (Current)
- UIKit `@IBOutlet` generation
- Build plugin integration
- Deterministic identifiers
- JSON export
- SwiftLint compatibility
- Manual application methods

### Phase 2 (Future)
- Stable keys via annotations (`@AutoAX("custom.id")`)
- SwiftUI support
- Optional safe swizzle for base classes
- Incremental generation with caching
- Programmatic view detection

### Phase 3 (Advanced)
- Accessibility audit checks
- CI enforcement / lint rules
- Xcode Source Editor Extension
- Visual identifier inspector

---

## FAQ

**Q: Does this modify my source files?**  
A: No. NSAutoAXKit generates extension files in the build directory. Your source files are never touched.

**Q: What if I rename a property?**  
A: The identifier updates automatically on the next build.

**Q: Can I customize the identifier format?**  
A: Not in MVP. Phase 2 will support custom annotations like `@AutoAX("my.custom.id")`.

**Q: Does this work with programmatic UI?**  
A: Not in MVP. It only processes `@IBOutlet` properties. Programmatic view support is planned for Phase 2.

**Q: What's the performance impact?**  
A: Minimal. Generation happens at build time. Runtime overhead is one method call per view controller.

**Q: Does it work with SwiftUI?**  
A: Not yet. SwiftUI requires a different approach (modifiers vs property assignment). Planned for Phase 2.

**Q: Can I use this in an Objective-C project?**  
A: NSAutoAXKit is Swift-only. Mixed Swift/ObjC projects can use it for Swift view controllers.

---

## Contributing

Contributions are welcome. Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Follow Swift API Design Guidelines and the project's code style (see `RULES.md`)
4. Add tests for new functionality
5. Ensure `swift test` passes
6. Submit a pull request

### Development Setup

```bash
git clone https://github.com/yourorg/NSAutoAXKit.git
cd NSAutoAXKit
swift build
swift test
```

---

## License

NSAutoAXKit is released under the MIT License. See [LICENSE](LICENSE) for details.

---

## Acknowledgments

- Built with [SwiftSyntax](https://github.com/apple/swift-syntax)
- Inspired by the need for better developer experience in iOS accessibility testing

---

## Support

- **Issues**: [GitHub Issues](https://github.com/yourorg/NSAutoAXKit/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourorg/NSAutoAXKit/discussions)

---

**NSAutoAXKit — Automate Accessibility. Accelerate Delivery.**
