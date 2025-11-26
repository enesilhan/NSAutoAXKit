{\rtf1\ansi\ansicpg1254\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 .SFNS-Regular_wdth_opsz110000_GRAD_wght2580000;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red255\green255\blue255;\red221\green221\blue221;
}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;\cssrgb\c100000\c100000\c100000;\cssrgb\c89412\c89412\c89412\c92157;
}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs27\fsmilli13800 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec4 # NSAutoAXKit Development Rules\
\
## Code Style\
- Swift API Design Guidelines\
- 4 spaces indentation\
- Max line length: 120 characters\
- Explicit types for public APIs\
- Implicit types for private/internal\
\
## Naming Conventions\
- Classes/Structs: PascalCase\
- Functions/Variables: camelCase\
- Constants: camelCase (not SCREAMING_CASE)\
- Generated files: `<Type>+AutoAX.swift`\
\
## Error Handling\
- Never force unwrap in production code\
- Use Result<T, Error> for fallible operations\
- Provide clear error messages with context\
- Log warnings, don't crash on parse errors\
\
## Documentation\
- Public APIs must have doc comments\
- Include code examples for complex APIs\
- Document edge cases and limitations\
\
## Testing\
- Unit tests for all public APIs\
- Integration tests for end-to-end flows\
- Test fixtures in Tests/Fixtures/\
- Mock external dependencies}