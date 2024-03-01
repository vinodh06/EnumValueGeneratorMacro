# EnumValueGeneratorMacro

EnumValueGeneratorMacro is a Swift package providing a convenient macro for generating static properties representing the raw values of enum cases.

## Installation

You can install EnumValueGeneratorMacro via Swift Package Manager. Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourgithubusername/EnumValueGenerator.git", from: "1.0.0")
]
```

## Usage

1. Import the EnumValueGeneratorMacro module into your Swift file.

```swift
import EnumValueGeneratorMacro
```

2. Use the `@enumValueGenerator` macro above your enum declaration to automatically generate static properties for each enum case.

```swift
@enumValueGenerator
enum Constants: String {
    case appName = "App Name"
}
```

3. EnumValueGenerator will create an extension with computed properties similar to the case names, prefixed with an underscore `_`.

```swift
extension Constants {
    static let _appName = Constants.appName.rawValue
}
```

Now you can access the raw values of enum cases conveniently using the generated static properties.

## Example

```swift
print(Constants._appName) // Output: "App Name"
```

