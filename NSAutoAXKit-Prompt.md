{\rtf1\ansi\ansicpg1254\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;\f1\fnil\fcharset0 Menlo-Italic;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red255\green255\blue255;\red205\green204\blue213;
\red221\green221\blue221;\red245\green188\blue80;\red218\green124\blue212;\red114\green201\blue195;\red233\green160\blue109;
\red118\green180\blue255;\red191\green102\blue119;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;\cssrgb\c100000\c100000\c100000;\cssrgb\c83922\c83922\c86667;
\cssrgb\c89412\c89412\c89412;\cssrgb\c97255\c78039\c38431;\cssrgb\c89020\c58039\c86275;\cssrgb\c50980\c82353\c80784;\cssrgb\c93725\c69020\c50196;
\cssrgb\c52941\c76471\c100000;\cssrgb\c80000\c48627\c54118;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs24 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec4 # NSAutoAXKit \'97 Vision-Driven Auto Accessibility Identifier Platform\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Developer Experience \'95 Automation \'95 Reliability**\strokec5 \
\
---\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ## \uc0\u55356 \u57263  Product Vision\strokec5 \
\
NSAutoAXKit is a production-grade developer experience tool that eliminates the pain of manually maintaining accessibility identifiers, improves UI test reliability, and scales across large iOS codebases.\
\
---\
\
\strokec4 ## \uc0\u55357 \u56960  Primary Goal (MVP)\strokec5 \
\
Build a Swift Package (SPM) that automatically generates and applies accessibility identifiers for \strokec6 **UIKit**\strokec5  UI elements with minimal developer effort, focusing on correctness, stability, and zero surprises.\
\
> \strokec6 **Important:**\strokec5  Do not assume the package can modify user source files during build. SPM build tool plugins generally generate outputs but must not rewrite developer files. Prefer safe, deterministic generation and opt-in runtime behavior.\
\
---\
\
\strokec4 ## \uc0\u55357 \u56523  Scope & Non-Goals\strokec5 \
\
\strokec4 ### \uc0\u9989  MVP Scope\strokec5 \
\
\strokec4 -\strokec5  \strokec6 **UIKit projects:**\strokec5  Storyboard/XIB + programmatic UI\
\strokec4 -\strokec5  \strokec6 **Primary targets:**\strokec5 \
  \strokec4 -\strokec5  \strokec7 `@IBOutlet`\strokec5  properties in \strokec7 `UIViewController`\strokec5 , \strokec7 `UIView`\strokec5 , \strokec7 `UITableViewCell`\strokec5 , \strokec7 `UICollectionViewCell`\strokec5 \
  \strokec4 -\strokec5  Common UIKit controls: \strokec7 `UILabel`\strokec5 , \strokec7 `UIButton`\strokec5 , \strokec7 `UITextField`\strokec5 , \strokec7 `UIImageView`\strokec5 , etc.\
\strokec4 -\strokec5  \strokec6 **Generate deterministic identifiers:**\strokec5  \strokec7 `TypeName.propertyName`\strokec5 \
\strokec4 -\strokec5  \strokec6 **Optional JSON export for QA:**\strokec5  \strokec7 `AutoAXIdentifiers.json`\strokec5 \
\
\strokec4 ### \uc0\u10060  Not in MVP (Phase 2+)\strokec5 \
\
\strokec4 -\strokec5  Full SwiftUI auto-identifiers (requires different approach via \strokec7 `.accessibilityIdentifier()`\strokec5 )\
\strokec4 -\strokec5  Runtime method swizzling by default (may be offered as \strokec6 **opt-in**\strokec5 )\
\strokec4 -\strokec5  Auto-injecting \strokec7 `applyAutoAX()`\strokec5  calls into user source files (not reliable/allowed in many setups)\
\strokec4 -\strokec5  Dynamic view hierarchies (views added programmatically in \strokec7 `viewDidLoad`\strokec5 )\
\
---\
\
\strokec4 ## \uc0\u55356 \u57256  Key Product Principles\strokec5 \
\
\strokec4 -\strokec5  \strokec6 **DX-first:**\strokec5  minimal adoption friction, predictable behavior\
\strokec4 -\strokec5  \strokec6 **Safe by default:**\strokec5  never break runtime UI, never block builds unexpectedly\
\strokec4 -\strokec5  \strokec6 **Idempotent:**\strokec5  repeated builds yield the same clean output with no duplicates\
\strokec4 -\strokec5  \strokec6 **Refactor-aware:**\strokec5  regenerated outputs must reflect renames deterministically\
\strokec4 -\strokec5  \strokec6 **Large-codebase ready:**\strokec5  incremental generation & caching\
\strokec4 -\strokec5  \strokec6 **Tooling-friendly:**\strokec5  SwiftLint/Periphery compatible (generated files handled cleanly)\
\
---\
\
\strokec4 ## \uc0\u55356 \u57335 \u65039  Identifier Strategy\strokec5 \
\
\strokec4 ### Default Format (Deterministic)\strokec5 \
\
```\
<OwnerType>.<propertyName>\
```\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Examples:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  \strokec7 `LoginViewController.loginButton`\strokec5 \
\strokec4 -\strokec5  \strokec7 `CheckoutView.headerTitleLabel`\strokec5 \
\strokec4 -\strokec5  \strokec7 `ProfileCell.avatarImageView`\strokec5 \
\
\strokec4 ### Stability Modes\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **1) Deterministic Mode (default):**\strokec5  Always \strokec7 `Type.property`\strokec5 \
\
\strokec6 **2) Stable Mode (Phase 2, opt-in):**\strokec5  Developer supplies a stable key:\
   \strokec4 -\strokec5  Annotation-style: \strokec7 `@AutoAX("login.button")`\strokec5 \
   \strokec4 -\strokec5  Or comment marker: \strokec7 `// autoax: login.button`\strokec5 \
\
Output must prefer stable keys when present.\
\
---\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ## \uc0\u55356 \u57303 \u65039  Architecture Requirements (3 Components)\strokec5 \
\
\strokec4 ### 1\uc0\u65039 \u8419  Runtime Module \'97 \strokec7 `Sources/NSAutoAXKit/`\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Purpose:**\strokec5  Lightweight API to apply generated identifiers\
\
\strokec6 **Must include:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  No heavy dependencies\
\strokec4 -\strokec5  Safe fallback behavior\
\strokec4 -\strokec5  Utilities for manual application\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Runtime Approach (choose Option A for MVP):**\strokec5 \
\
\strokec6 **Option A (Recommended):**\strokec5  Generated extensions expose \strokec7 `applyAutoAX()`\strokec5  and the app calls it from a common base class/hook.\
\
\strokec6 **Option B (Phase 2):**\strokec5  Provide a runtime installer that swizzles \strokec7 `viewDidLoad`\strokec5  for specified base classes only (never global swizzle by default).\
\
\strokec6 **API Requirements:**\strokec5 \
\
```swift\
\pard\pardeftab720\partightenfactor0

\f1\i \cf2 // Utility for manual application
\f0\i0 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec8 public\strokec5  \strokec8 struct\strokec5  \strokec9 AutoAX\strokec5  \{\
    \strokec8 public\strokec5  \strokec8 static\strokec5  \strokec8 func\strokec5  \strokec9 apply\strokec5 (\strokec9 to\strokec5  
\f1\i \strokec4 view
\f0\i0 \strokec5 : UIView)\
    \strokec8 public\strokec5  \strokec8 static\strokec5  \strokec8 func\strokec5  \strokec9 apply\strokec5 (\strokec9 to\strokec5  
\f1\i \strokec4 viewController
\f0\i0 \strokec5 : UIViewController)\
\}\
\
\pard\pardeftab720\partightenfactor0

\f1\i \cf2 // Helper for base class integration
\f0\i0 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec8 extension\strokec5  \strokec9 UIViewController\strokec5  \{\
    \strokec8 public\strokec5  \strokec8 func\strokec5  \strokec9 applyAutoAXIfAvailable\strokec5 ()\
\}\
\
\strokec8 extension\strokec5  \strokec9 UIView\strokec5  \{\
    \strokec8 public\strokec5  \strokec8 func\strokec5  \strokec9 applyAutoAXIfAvailable\strokec5 ()\
\}\
```\
\
---\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ### 2\uc0\u65039 \u8419  Generator Tool \'97 \strokec7 `Sources/NSAutoAXGenerator/`\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Purpose:**\strokec5  CLI tool that scans Swift sources and generates identifier code\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 #### Input Contract\strokec5 \
\
```bash\
\pard\pardeftab720\partightenfactor0

\f1\i \cf2 # Command line interface
\f0\i0 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec9 autoax-generator\strokec5  \strokec4 \\\strokec5 \
  --input-paths <path1> <path2> ... \\\
  \strokec7 --output-dir\strokec5  \strokec4 <\strokec7 generated-di\strokec5 r\strokec4 >\strokec5  \strokec4 \\\strokec5 \
  --json-output <optional-json-path>\
```\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Arguments:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  \strokec7 `--input-paths`\strokec5 : List of .swift files or directories to scan\
\strokec4 -\strokec5  \strokec7 `--output-dir`\strokec5 : Where to write generated Swift files\
\strokec4 -\strokec5  \strokec7 `--json-output`\strokec5 : Optional path for JSON export\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Exit codes:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  \strokec7 `0`\strokec5  = success\
\strokec4 -\strokec5  \strokec7 `1`\strokec5  = parsing error\
\strokec4 -\strokec5  \strokec7 `2`\strokec5  = invalid arguments\
\
\strokec4 #### Output Contract\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Generated Files:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  One Swift file per scanned type containing \strokec7 `@IBOutlet`\strokec5 s\
\strokec4 -\strokec5  Naming convention: \strokec7 `<TypeName>+AutoAX.swift`\strokec5 \
  \strokec4 -\strokec5  Example: \strokec7 `LoginViewController+AutoAX.swift`\strokec5 \
\strokec4 -\strokec5  Each file contains a single extension with \strokec7 `applyAutoAX()`\strokec5  method\
\strokec4 -\strokec5  Files include header comment with:\
  \strokec4 -\strokec5  Generation timestamp\
  \strokec4 -\strokec5  Source file path\
  \strokec4 -\strokec5  Generator version\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Example Generated File:**\strokec5 \
\
```swift\
\pard\pardeftab720\partightenfactor0

\f1\i \cf2 // LoginViewController+AutoAX.swift
\f0\i0 \

\f1\i // Auto-generated by NSAutoAXKit on 2025-11-26T10:30:00Z
\f0\i0 \

\f1\i // Source: /path/to/LoginViewController.swift
\f0\i0 \

\f1\i // Generator version: 1.0.0
\f0\i0 \

\f1\i // swiftlint:disable all
\f0\i0 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec8 import\strokec5  \strokec9 UIKit\strokec5 \
\
\strokec8 extension\strokec5  \strokec9 LoginViewController\strokec5  \{\
    \strokec8 func\strokec5  \strokec9 applyAutoAX\strokec5 () \{\
        emailField\strokec4 ?\strokec5 .\strokec4 accessibilityIdentifier\strokec5  \strokec4 =\strokec5  \strokec7 "LoginViewController.emailField"\strokec5 \
        passwordField\strokec4 ?\strokec5 .\strokec4 accessibilityIdentifier\strokec5  \strokec4 =\strokec5  \strokec7 "LoginViewController.passwordField"\strokec5 \
        loginButton\strokec4 ?\strokec5 .\strokec4 accessibilityIdentifier\strokec5  \strokec4 =\strokec5  \strokec7 "LoginViewController.loginButton"\strokec5 \
    \}\
\}\
```\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 #### Generation Rules\strokec5 \
\
\strokec4 -\strokec5  \strokec6 **Output location:**\strokec5  Plugin work directory (not user source tree)\
\strokec4 -\strokec5  \strokec6 **Deterministic file naming:**\strokec5  Avoid duplicates\
\strokec4 -\strokec5  \strokec6 **Idempotent output:**\strokec5  Same input always produces same output\
\strokec4 -\strokec5  \strokec6 **Must not overwrite developer files**\strokec5 \
\strokec4 -\strokec5  \strokec6 **Incremental support:**\strokec5 \
  \strokec4 -\strokec5  Hash input files (path + content)\
  \strokec4 -\strokec5  Store hash in \strokec7 `<workDir>/.autoax-cache`\strokec5 \
  \strokec4 -\strokec5  Regenerate only if hash changed\
  \strokec4 -\strokec5  (Or accept full regeneration as MVP fallback)\
\
\strokec4 #### SwiftSyntax Strategy\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **MVP Approach:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Use SwiftSyntax 509.x (compatible with Swift 5.9+)\
\strokec4 -\strokec5  Generator tool must be built as executable, not library\
\strokec4 -\strokec5  SPM will use active toolchain's SwiftSyntax\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Compatibility Requirements:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Minimum Swift version: 5.9\
\strokec4 -\strokec5  Minimum Xcode version: 15.0\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Error Handling:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  If SwiftSyntax import fails, emit clear error:\
  ```\
  NSAutoAXKit requires Swift 5.9+ toolchain. Current: <version>\
  ```\
\strokec4 -\strokec5  Provide fallback: regex-based parser (less accurate, acceptable for MVP)\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Parsing Logic:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 1.\strokec5  Find all class/struct declarations that inherit from:\
   \strokec4 -\strokec5  \strokec7 `UIViewController`\strokec5 \
   \strokec4 -\strokec5  \strokec7 `UIView`\strokec5 \
   \strokec4 -\strokec5  \strokec7 `UITableViewCell`\strokec5 \
   \strokec4 -\strokec5  \strokec7 `UICollectionViewCell`\strokec5 \
\strokec4 2.\strokec5  Extract all \strokec7 `@IBOutlet`\strokec5  properties\
\strokec4 3.\strokec5  Filter to UIKit types only (UILabel, UIButton, UITextField, etc.)\
\strokec4 4.\strokec5  Generate identifier: \strokec7 `<ClassName>.<propertyName>`\strokec5 \
\strokec4 5.\strokec5  Generate extension with \strokec7 `applyAutoAX()`\strokec5  method\
\
---\
\
\strokec4 ### 3\uc0\u65039 \u8419  Build Tool Plugin \'97 \strokec7 `Plugins/AutoAXPlugin/`\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Purpose:**\strokec5  Automatically run generator during build and register outputs\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 #### Plugin Behavior Specification\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Input Discovery:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Plugin must discover all \strokec7 `.swift`\strokec5  files in the target's source directories\
\strokec4 -\strokec5  \strokec6 **Exclude:**\strokec5 \
  \strokec4 -\strokec5  \strokec7 `Tests/`\strokec5 \
  \strokec4 -\strokec5  \strokec7 `Generated/`\strokec5 \
  \strokec4 -\strokec5  \strokec7 `.build/`\strokec5 \
  \strokec4 -\strokec5  Any path containing \strokec7 `.generated`\strokec5 \
\strokec4 -\strokec5  Pass discovered paths to generator tool\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Output Registration:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Generated files must be placed in plugin's work directory\
\strokec4 -\strokec5  Plugin must register outputs via \strokec7 `outputFilesDirectory`\strokec5  API\
\strokec4 -\strokec5  Xcode/SPM will automatically compile registered outputs\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Incremental Build Strategy (MVP):**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Option 1: Hash input file list + contents, skip if unchanged\
\strokec4 -\strokec5  Option 2: Accept full regeneration on every build (simpler, acceptable)\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Error Handling:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  If generator fails, plugin must emit clear diagnostic\
\strokec4 -\strokec5  Build should continue (non-fatal) unless \strokec7 `--strict`\strokec5  flag set\
\strokec4 -\strokec5  Log generator stderr to build output\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Implementation Requirements:**\strokec5 \
\
```swift\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec8 import\strokec5  \strokec9 PackagePlugin\strokec5 \
\
\strokec8 @main\strokec5 \
\strokec8 struct\strokec5  \strokec9 AutoAXPlugin\strokec5 : \strokec9 BuildToolPlugin \strokec5 \{\
    \strokec8 func\strokec5  \strokec9 createBuildCommands\strokec5 (\
        
\f1\i \strokec9 context
\f0\i0 \strokec5 : PluginContext,\
        
\f1\i \strokec9 target
\f0\i0 \strokec5 : Target\
    ) \strokec8 async\strokec5  \strokec8 throws\strokec5  \strokec4 ->\strokec5  [Command] \{\
        
\f1\i // 1. Discover .swift files in target
\f0\i0 \
        
\f1\i // 2. Run generator tool
\f0\i0 \
        
\f1\i // 3. Register generated outputs
\f0\i0 \
    \}\
\}\
```\
\
---\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ## \uc0\u55358 \u56810  Testing Requirements\strokec5 \
\
\strokec4 ### Generator Tests\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Test Cases:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Parse sample ViewControllers with various outlet types\
\strokec4 -\strokec5  Verify correct identifier generation\
\strokec4 -\strokec5  Test duplicate property name handling (append \strokec7 `_1`\strokec5 , \strokec7 `_2`\strokec5 )\
\strokec4 -\strokec5  Test invalid Swift syntax handling (should skip with warning)\
\strokec4 -\strokec5  Test empty files (should produce no output)\
\strokec4 -\strokec5  Test non-UIKit outlets (should skip with warning)\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Test Fixtures:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  \strokec7 `Tests/Fixtures/SampleViewController.swift`\strokec5 \
\strokec4 -\strokec5  \strokec7 `Tests/Fixtures/InvalidSyntax.swift`\strokec5 \
\strokec4 -\strokec5  \strokec7 `Tests/Fixtures/EmptyFile.swift`\strokec5 \
\
\strokec4 ### Plugin Tests\strokec5 \
\
\strokec4 -\strokec5  Mock SPM plugin context\
\strokec4 -\strokec5  Verify file discovery logic\
\strokec4 -\strokec5  Verify output registration\
\strokec4 -\strokec5  Verify incremental build cache\
\
\strokec4 ### Integration Test\strokec5 \
\
\strokec4 -\strokec5  Sample iOS app with package integrated\
\strokec4 -\strokec5  Verify identifiers applied at runtime\
\strokec4 -\strokec5  Verify JSON export correctness\
\strokec4 -\strokec5  Verify Accessibility Inspector shows identifiers\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Acceptance Criteria:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  \strokec7 `swift test`\strokec5  passes on macOS 13+\
\strokec4 -\strokec5  Sample app builds and runs with identifiers visible in Accessibility Inspector\
\strokec4 -\strokec5  JSON export matches expected schema\
\
---\
\
\strokec4 ## \uc0\u55357 \u56516  JSON Export Specification\strokec5 \
\
\strokec4 ### File Output\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Filename:**\strokec5  \strokec7 `AutoAXIdentifiers.json`\strokec5 \
\
\strokec6 **Location:**\strokec5  \strokec7 `<output-dir>/AutoAXIdentifiers.json`\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ### Schema\strokec5 \
\
```json\
\{\
  \strokec8 "generated_at"\strokec5 : \strokec7 "2025-11-26T10:30:00Z"\strokec5 ,\
  \strokec8 "generator_version"\strokec5 : \strokec7 "1.0.0"\strokec5 ,\
  \strokec8 "identifiers"\strokec5 : \{\
    \strokec8 "LoginViewController"\strokec5 : \{\
      \strokec8 "emailField"\strokec5 : \strokec7 "LoginViewController.emailField"\strokec5 ,\
      \strokec8 "passwordField"\strokec5 : \strokec7 "LoginViewController.passwordField"\strokec5 ,\
      \strokec8 "loginButton"\strokec5 : \strokec7 "LoginViewController.loginButton"\strokec5 \
    \},\
    \strokec8 "CheckoutView"\strokec5 : \{\
      \strokec8 "headerLabel"\strokec5 : \strokec7 "CheckoutView.headerLabel"\strokec5 ,\
      \strokec8 "priceLabel"\strokec5 : \strokec7 "CheckoutView.priceLabel"\strokec5 \
    \}\
  \}\
\}\
```\
\
\strokec4 ### QA Usage Example\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **XCUITest Integration:**\strokec5 \
\
```swift\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec8 struct\strokec5  \strokec9 AutoAXIdentifiers\strokec5 : \strokec9 Codable \strokec5 \{\
    \strokec8 let\strokec5  generated_at: \strokec9 String\strokec5 \
    \strokec8 let\strokec5  generator_version: \strokec9 String\strokec5 \
    \strokec8 let\strokec5  identifiers: [\strokec9 String\strokec4 :\strokec5  [\strokec9 String\strokec4 :\strokec5  \strokec9 String\strokec5 ]]\
\}\
\
\pard\pardeftab720\partightenfactor0

\f1\i \cf2 // In test:
\f0\i0 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec8 let\strokec5  jsonData \strokec4 =\strokec5  \strokec8 try\strokec5  \strokec9 Data\strokec5 (\strokec9 contentsOf\strokec5 : jsonURL)\
\strokec8 let\strokec5  ids \strokec4 =\strokec5  \strokec8 try\strokec5  \strokec9 JSONDecoder\strokec5 ().\strokec9 decode\strokec5 (AutoAXIdentifiers.\strokec8 self\strokec5 , \strokec9 from\strokec5 : jsonData)\
\strokec8 let\strokec5  loginButtonID \strokec4 =\strokec5  ids.\strokec4 identifiers\strokec5 [\strokec7 "LoginViewController"\strokec5 ]\strokec4 ?\strokec5 [\strokec7 "loginButton"\strokec5 ]\
app.\strokec4 buttons\strokec5 [loginButtonID\strokec4 !\strokec5 ].\strokec9 tap\strokec5 ()\
```\
\
---\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ## \uc0\u55357 \u56615  Tooling Compatibility\strokec5 \
\
\strokec4 ### SwiftLint\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Generated File Header:**\strokec5 \
\
```swift\
\pard\pardeftab720\partightenfactor0

\f1\i \cf2 // This file is auto-generated by NSAutoAXKit. Do not edit.
\f0\i0 \

\f1\i // swiftlint:disable all
\f0\i0 \
```\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Recommended \strokec7 `.swiftlint.yml`\strokec6 :**\strokec5 \
\
```yaml\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec7 excluded\strokec5 :\
  \strokec4 -\strokec5  \strokec7 .build\strokec5 \
  \strokec4 -\strokec5  \strokec7 DerivedData\strokec5 \
  \strokec4 -\strokec5  \strokec7 .autoax-generated\strokec5 \
  \strokec4 -\strokec5  \strokec7 "**/Generated"\strokec5 \
```\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ### Periphery / Unused Code Tools\strokec5 \
\
\strokec4 -\strokec5  Generated code might appear unused\
\strokec4 -\strokec5  Provide guidance to exclude generated folder\
\strokec4 -\strokec5  Or use \strokec7 `@_spi`\strokec5  / explicit references\
\
---\
\
\strokec4 ## \uc0\u55357 \u56424 \u8205 \u55357 \u56507  Developer Adoption Experience\strokec5 \
\
\strokec4 ### Installation\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Package.swift:**\strokec5 \
\
```swift\
dependencies\strokec8 :\strokec5  [\
    .\strokec9 package\strokec5 (\strokec9 url\strokec5 : \strokec7 "https://github.com/yourorg/NSAutoAXKit"\strokec5 , \strokec9 from\strokec5 : \strokec7 "1.0.0"\strokec5 )\
]\
\
targets\strokec8 :\strokec5  [\
    .\strokec9 target\strokec5 (\
        \strokec9 name\strokec5 : \strokec7 "YourApp"\strokec5 ,\
        \strokec9 dependencies\strokec5 : [\strokec7 "NSAutoAXKit"\strokec5 ],\
        \strokec9 plugins\strokec5 : [\strokec7 "AutoAXPlugin"\strokec5 ]\
    )\
]\
```\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ### Integration (Option A - Manual Calls)\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Base ViewController:**\strokec5 \
\
```swift\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec8 import\strokec5  \strokec9 NSAutoAXKit\strokec5 \
\
\strokec8 class\strokec5  \strokec10 BaseViewController\strokec5 : \strokec9 UIViewController \strokec5 \{\
    \strokec8 override\strokec5  \strokec8 func\strokec5  \strokec9 viewDidLoad\strokec5 () \{\
        \strokec11 super\strokec5 .\strokec9 viewDidLoad\strokec5 ()\
        \strokec9 applyAutoAXIfAvailable\strokec5 () 
\f1\i // Runtime helper checks if method exists
\f0\i0 \
    \}\
\}\
```\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Individual ViewController:**\strokec5 \
\
```swift\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec8 class\strokec5  \strokec10 LoginViewController\strokec5 : \strokec9 UIViewController \strokec5 \{\
    \strokec8 @IBOutlet\strokec5  \strokec8 weak\strokec5  \strokec8 var\strokec5  emailField: UITextField\strokec4 !\strokec5 \
    \strokec8 @IBOutlet\strokec5  \strokec8 weak\strokec5  \strokec8 var\strokec5  loginButton: UIButton\strokec4 !\strokec5 \
    \
    \strokec8 override\strokec5  \strokec8 func\strokec5  \strokec9 viewDidLoad\strokec5 () \{\
        \strokec11 super\strokec5 .\strokec9 viewDidLoad\strokec5 ()\
        \strokec9 applyAutoAX\strokec5 () 
\f1\i // Generated method
\f0\i0 \
    \}\
\}\
```\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ### Integration (Option B - AppDelegate Setup)\strokec5 \
\
```swift\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec8 import\strokec5  \strokec9 NSAutoAXKit\strokec5 \
\
\strokec8 @main\strokec5 \
\strokec8 class\strokec5  \strokec10 AppDelegate\strokec5 : \strokec9 UIResponder\strokec5 , \strokec9 UIApplicationDelegate \strokec5 \{\
    \strokec8 func\strokec5  \strokec9 application\strokec5 (\
        \strokec9 _\strokec5  
\f1\i \strokec4 application
\f0\i0 \strokec5 : UIApplication,\
        \strokec9 didFinishLaunchingWithOptions\strokec5  
\f1\i \strokec4 launchOptions
\f0\i0 \strokec5 : [UIApplication.LaunchOptionsKey\strokec4 :\strokec5  Any]\strokec4 ?\strokec5 \
    ) \strokec4 ->\strokec5  \strokec9 Bool\strokec5  \{\
        AutoAX.\strokec9 installGlobalHook\strokec5 () 
\f1\i // Phase 2 feature
\f0\i0 \
        \strokec8 return\strokec5  true\
    \}\
\}\
```\
\
---\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ## \uc0\u9888 \u65039  Known Limitations & Error Cases\strokec5 \
\
\strokec4 ### MVP Limitations\strokec5 \
\
\strokec4 -\strokec5  Only detects \strokec7 `@IBOutlet`\strokec5  properties (not programmatic views)\
\strokec4 -\strokec5  Does not handle dynamic view hierarchies (e.g., views added in \strokec7 `viewDidLoad`\strokec5 )\
\strokec4 -\strokec5  Does not support SwiftUI (Phase 2)\
\strokec4 -\strokec5  Does not auto-inject calls (developer must call \strokec7 `applyAutoAX()`\strokec5 )\
\strokec4 -\strokec5  Requires Swift 5.9+ / Xcode 15.0+\
\
\strokec4 ### Error Handling\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Duplicate property names in same type:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Append index: \strokec7 `button_1`\strokec5 , \strokec7 `button_2`\strokec5 \
\strokec4 -\strokec5  Emit warning in build log\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Non-UIKit outlets:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Skip with warning: "Skipping non-UIKit outlet: customObject"\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Parsing failures:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Log file path + line number\
\strokec4 -\strokec5  Continue with other files\
\strokec4 -\strokec5  Do not fail build\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Empty outputs:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Emit warning: "No @IBOutlet properties found"\
\strokec4 -\strokec5  Do not fail build\
\
\strokec4 ### CI Considerations\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Generated Files:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  \strokec6 **Option 1 (Recommended):**\strokec5  Gitignore (regenerated on each build)\
\strokec4 -\strokec5  \strokec6 **Option 2:**\strokec5  Commit (stable diffs, faster CI builds)\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Provide guidance for both approaches in README**\strokec5 \
\
---\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 ## \uc0\u55357 \u56550  Deliverables Required\strokec5 \
\
\strokec4 ### 1. Package Structure\strokec5 \
\
```\
NSAutoAXKit/\
\uc0\u9500 \u9472 \u9472  Package.swift\
\uc0\u9500 \u9472 \u9472  README.md\
\uc0\u9500 \u9472 \u9472  LICENSE\
\uc0\u9500 \u9472 \u9472  Sources/\
\uc0\u9474    \u9500 \u9472 \u9472  NSAutoAXKit/              # Runtime module\
\uc0\u9474    \u9474    \u9500 \u9472 \u9472  AutoAX.swift\
\uc0\u9474    \u9474    \u9500 \u9472 \u9472  UIViewController+AutoAX.swift\
\uc0\u9474    \u9474    \u9492 \u9472 \u9472  UIView+AutoAX.swift\
\uc0\u9474    \u9492 \u9472 \u9472  NSAutoAXGenerator/        # Generator tool\
\uc0\u9474        \u9500 \u9472 \u9472  main.swift\
\uc0\u9474        \u9500 \u9472 \u9472  SourceParser.swift\
\uc0\u9474        \u9500 \u9472 \u9472  IdentifierGenerator.swift\
\uc0\u9474        \u9492 \u9472 \u9472  JSONExporter.swift\
\uc0\u9500 \u9472 \u9472  Plugins/\
\uc0\u9474    \u9492 \u9472 \u9472  AutoAXPlugin/\
\uc0\u9474        \u9492 \u9472 \u9472  AutoAXPlugin.swift\
\uc0\u9492 \u9472 \u9472  Tests/\
    \uc0\u9500 \u9472 \u9472  NSAutoAXKitTests/\
    \uc0\u9500 \u9472 \u9472  NSAutoAXGeneratorTests/\
    \uc0\u9492 \u9472 \u9472  Fixtures/\
        \uc0\u9500 \u9472 \u9472  SampleViewController.swift\
        \uc0\u9492 \u9472 \u9472  SampleView.swift\
```\
\
\strokec4 ### 2. Package.swift (Full Configuration)\strokec5 \
\
Must include:\
\strokec4 -\strokec5  Runtime module as library\
\strokec4 -\strokec5  Generator tool as executable\
\strokec4 -\strokec5  Build tool plugin\
\strokec4 -\strokec5  SwiftSyntax dependency for generator\
\strokec4 -\strokec5  Platform requirements (iOS 13+, macOS 13+)\
\
\strokec4 ### 3. Complete Source Code\strokec5 \
\
\strokec4 -\strokec5  Runtime module implementation\
\strokec4 -\strokec5  Generator tool with SwiftSyntax parser\
\strokec4 -\strokec5  Build plugin implementation\
\strokec4 -\strokec5  JSON exporter\
\strokec4 -\strokec5  All utilities and helpers\
\
\strokec4 ### 4. README.md\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Required Sections:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  What it solves (problem statement)\
\strokec4 -\strokec5  Installation (SPM)\
\strokec4 -\strokec5  Quick Start (minimal integration)\
\strokec4 -\strokec5  Integration Options (manual vs base class)\
\strokec4 -\strokec5  SwiftLint/Periphery guidance\
\strokec4 -\strokec5  CI/CD setup\
\strokec4 -\strokec5  Troubleshooting\
\strokec4 -\strokec5  FAQ\
\strokec4 -\strokec5  Roadmap (Phase 2 features)\
\strokec4 -\strokec5  Contributing\
\strokec4 -\strokec5  License\
\
\strokec4 ### 5. Tests\strokec5 \
\
\strokec4 -\strokec5  Unit tests for generator\
\strokec4 -\strokec5  Integration tests with sample app\
\strokec4 -\strokec5  Test fixtures\
\strokec4 -\strokec5  CI configuration (GitHub Actions example)\
\
\strokec4 ### 6. Documentation\strokec5 \
\
\strokec4 -\strokec5  Inline code documentation\
\strokec4 -\strokec5  Architecture overview\
\strokec4 -\strokec5  API reference\
\strokec4 -\strokec5  Migration guide (if applicable)\
\
---\
\
\strokec4 ## \uc0\u55357 \u56960  Phased Implementation Plan\strokec5 \
\
\strokec4 ### Phase 1 (MVP) \'97 Implement Now\strokec5 \
\
\strokec4 -\strokec5  \uc0\u9989  UIKit \strokec7 `@IBOutlet`\strokec5  generation\
\strokec4 -\strokec5  \uc0\u9989  Build plugin integration\
\strokec4 -\strokec5  \uc0\u9989  Deterministic identifiers\
\strokec4 -\strokec5  \uc0\u9989  JSON export\
\strokec4 -\strokec5  \uc0\u9989  SwiftLint guidance\
\strokec4 -\strokec5  \uc0\u9989  Manual \strokec7 `applyAutoAX()`\strokec5  calls\
\strokec4 -\strokec5  \uc0\u9989  Runtime helpers (\strokec7 `applyAutoAXIfAvailable()`\strokec5 )\
\
\strokec4 ### Phase 2 (Future)\strokec5 \
\
\strokec4 -\strokec5  Stable keys via annotations (\strokec7 `@AutoAX("custom.id")`\strokec5 )\
\strokec4 -\strokec5  SwiftUI support strategy\
\strokec4 -\strokec5  Optional safe swizzle for base classes only\
\strokec4 -\strokec5  Programmatic view detection\
\strokec4 -\strokec5  Snapshot test labeling\
\
\strokec4 ### Phase 3 (Advanced)\strokec5 \
\
\strokec4 -\strokec5  Accessibility audit checks (missing labels/hints)\
\strokec4 -\strokec5  CI enforcement/lint rules\
\strokec4 -\strokec5  Xcode Source Editor Extension\
\strokec4 -\strokec5  Visual identifier inspector\
\
---\
\
\strokec4 ## \uc0\u55356 \u57263  Mission Statement\strokec5 \
\
> "NSAutoAXKit should feel like a polished, production-grade DX platform: \strokec6 **Automatic, consistent accessibility identifiers for reliable UI testing \'97 with minimal developer effort and maximum safety.**\strokec5 "\
\
---\
\
\strokec4 ## \uc0\u9989  Implementation Checklist\strokec5 \
\
Before considering the package complete, verify:\
\
\strokec4 -\strokec5  [ ] \strokec7 `swift build`\strokec5  succeeds on macOS 13+\
\strokec4 -\strokec5  [ ] \strokec7 `swift test`\strokec5  passes all tests\
\strokec4 -\strokec5  [ ] Sample iOS app builds with plugin enabled\
\strokec4 -\strokec5  [ ] Generated identifiers visible in Accessibility Inspector\
\strokec4 -\strokec5  [ ] JSON export produces valid schema\
\strokec4 -\strokec5  [ ] README includes all required sections\
\strokec4 -\strokec5  [ ] SwiftLint excludes generated files\
\strokec4 -\strokec5  [ ] Error messages are clear and actionable\
\strokec4 -\strokec5  [ ] No warnings in Xcode build output\
\strokec4 -\strokec5  [ ] Plugin works in both Xcode and command-line builds\
\strokec4 -\strokec5  [ ] Generated code compiles without errors\
\strokec4 -\strokec5  [ ] Incremental builds work correctly (or full regeneration is acceptable)\
\
---\
\
\strokec4 ## \uc0\u55356 \u57281  Final Instructions\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Begin implementation now. Produce:**\strokec5 \
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 1.\strokec5  Full \strokec7 `Package.swift`\strokec5  with all targets configured\
\strokec4 2.\strokec5  Complete folder structure\
\strokec4 3.\strokec5  All source code for runtime, generator, and plugin\
\strokec4 4.\strokec5  Test suite with fixtures\
\strokec4 5.\strokec5  Comprehensive README.md\
\strokec4 6.\strokec5  Example integration in a sample app\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Quality Standards:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Production-grade code (clean, documented, tested)\
\strokec4 -\strokec5  Clear error messages\
\strokec4 -\strokec5  Defensive programming (handle edge cases)\
\strokec4 -\strokec5  Performance-conscious (fast builds)\
\strokec4 -\strokec5  DX-focused (minimal friction)\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **Deliverable Format:**\strokec5 \
\pard\pardeftab720\partightenfactor0
\cf2 \strokec4 -\strokec5  Complete, runnable Swift Package\
\strokec4 -\strokec5  Ready for GitHub release\
\strokec4 -\strokec5  All files included\
\strokec4 -\strokec5  No placeholders or TODOs\
\
---\
\
\pard\pardeftab720\partightenfactor0
\cf2 \strokec6 **NSAutoAXKit \'97 Automate Accessibility. Accelerate Delivery.**\strokec5 \
\
\pard\pardeftab720\partightenfactor0

\f1\i \cf2 \strokec8 *The zero-effort way to make your UI testable, stable, and future-proof.*
\f0\i0 \strokec5 \
\
\
}