/// A macro that generates static properties for each case of an enum, returning its raw value.
/// For example:
///
///     @EnumValueGenerator
///     enum Constants: String {
///         case appName = "App Name"
///     }
///
/// This creates an extension with computed properties similar to the case names, prefixed with an underscore '_',
/// like this:
///
///     extension Constants {
///         static let _appName = Constants.appName.rawValue
///     }
///

@attached(extension, names: arbitrary)
public macro enumValueGenerator() = #externalMacro(module: "EnumValueGeneratorMacroMacros", type: "EnumValueGeneratorMacro")
