import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroTesting

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EnumValueGeneratorMacroMacros)
import EnumValueGeneratorMacroMacros
#endif

final class EnumValueGeneratorMacroTests: XCTestCase {
    
    override func invokeTest() {
        withMacroTesting(macros: [
            "enumValueGenerator": EnumValueGeneratorMacro.self,
        ]) {
          super.invokeTest()
        }
    }

    func testMacro() throws {
        assertMacro {
            """
            @enumValueGenerator
            enum Constant: String {
                case appName = "App Name"
                case version = "1.0.0"
                case buildNo = "1.0.0"
            }
            """
        } expansion: {
            """
            enum Constant: String {
                case appName = "App Name"
                case version = "1.0.0"
                case buildNo = "1.0.0"
            }

            extension Constant {
                static let _appName = Constant.appName.rawValue
                static let _version = Constant.version.rawValue
                static let _buildNo = Constant.buildNo.rawValue
            }
            """
        }
    }

    func testStruct() throws {
        assertMacro {
            """
            @enumValueGenerator
            struct Constant {
                var appName = "App Name"
            }
            """
        } diagnostics: {
            """
            @enumValueGenerator
            ┬──────────────────
            ╰─ 🛑 The provided type is not an enum.
            struct Constant {
                var appName = "App Name"
            }
            """
        }
    }

    func testEnumWithoutRawRepresentable() throws {
        assertMacro {
            """
            @enumValueGenerator
            enum Constants {
                case appName
            }
            """
        } diagnostics: {
            """
            @enumValueGenerator
            ┬──────────────────
            ╰─ 🛑 The enum should conform to a type that is RawRepresentable.
            enum Constants {
                case appName
            }
            """
        }
    }
}

