import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EnumValueGeneratorMacro: ExtensionMacro {
    
    // Extensionmacro protocol function
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        
        // Ensure the provided declaration is an enum
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw EnumValueGeneratorError.notAnEnumType
        }
        
        // Ensure the enum conforms to a RawRepresentable type
        guard let _ = enumDecl.inheritanceClause else {
            throw EnumValueGeneratorError.shouldBeRawRepresentable
        }
        
        // Extract the name of the enum
        let enumName = enumDecl.name.text
        
        // Extract names of enum cases
        guard let caseDecls = enumDecl.memberBlock.as(MemberBlockSyntax.self)?.members.compactMap({ $0.as(MemberBlockItemSyntax.self) }) else {
            return []
        }
        
        let caseNames = caseDecls
            .compactMap({ $0.as(MemberBlockItemSyntax.self) })
            .compactMap({ $0.decl.as(EnumCaseDeclSyntax.self) })
            .compactMap({ $0.elements.as(EnumCaseElementListSyntax.self)?.compactMap({ $0.as(EnumCaseElementSyntax.self) }).compactMap({ $0.name.text }) }).flatMap({ $0 })
        
        // Generate code for extension
        let results = caseNames.map { "public static let _\($0) = \(enumName).\($0).rawValue" }.joined(separator: "\n")
        
        // Create extension declaration
        let constantExtension = try ExtensionDeclSyntax("""
         extension \(raw: enumName) {
         \(raw: results)
         }
         """)
        
        return [
            constantExtension
        ]
    }

    // Enum defining possible errors related to ConstantsExtensionMacro
    public enum EnumValueGeneratorError: Error, CustomStringConvertible {

        // Error case: The provided type is not an enumeration
        case notAnEnumType

        // Error case: The enumeration should conform to a type that is RawRepresentable
        case shouldBeRawRepresentable

        // Computed property to provide a human-readable description for each error case
        public var description: String {
            switch self {
            case .notAnEnumType:
                return "The provided type is not an enum."
            case .shouldBeRawRepresentable:
                return "The enum should conform to a type that is RawRepresentable."
            }
        }

    }
}

@main
struct EnumValueGeneratorPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumValueGeneratorMacro.self,
    ]
}
