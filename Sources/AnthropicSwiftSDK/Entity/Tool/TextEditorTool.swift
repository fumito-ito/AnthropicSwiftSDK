//
//  TextEditorTool.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/29.
//

/// A tool for viewing, creating and editing files.
///
/// This is one of the Anthropic-defined tools that enables Claude to manipulate text files.
/// When specifying this tool, `description` and `tool_schema` fields are not necessary or allowed.
///
/// Key features:
/// - State is persistent across command calls and discussions with the user
/// - Can view file contents with line numbers using `cat -n`
/// - Can list non-hidden files and directories up to 2 levels deep
/// - Supports file creation, string replacement, and line insertion
/// - Provides undo functionality for edits
///
/// Example usage:
/// ```swift
/// let textEditorTool = TextEditorTool(name: "str_replace_editor")
/// ```
public struct TextEditorTool {
    /// The version identifier for the text editor tool.
    ///
    /// Currently supports:
    /// - `textEditor_20241022`: The initial version of the text editor tool
    public enum TextEditorType: String, RawRepresentable, Encodable {
        /// The initial version of the text editor tool released on October 22, 2024
        case textEditor20241022 = "textEditor_20241022"
    }

    /// The type identifier for the tool. Used for validation purposes.
    public let type: TextEditorType

    /// The name of the tool that will be exposed to the model.
    ///
    /// - Note: The name must be unique within the tool list in an API call.
    /// While you can define a tool with a different name, using "str_replace_editor" is recommended
    /// as it may result in better model performance.
    public let name: String

    /// Creates a new text editor tool instance.
    /// - Parameters:
    ///   - type: The version of the text editor tool to use. Defaults to `.textEditor20241022`.
    ///   - name: The name of the tool that will be exposed to the model.
    public init(type: TextEditorType = .textEditor20241022, name: String) {
        self.type = type
        self.name = name
    }
}

extension TextEditorTool: Encodable {}
