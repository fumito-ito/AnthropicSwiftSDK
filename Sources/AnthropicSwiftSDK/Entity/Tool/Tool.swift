//
//  Tool.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/28.
//

/// A type representing the various tools that can be used with Claude.
///
/// This enum encapsulates both Anthropic-defined tools and custom function tools:
/// - Anthropic-defined tools:
///   - `computer`: Enables Claude to interact with a computer desktop environment
///   - `textEditor`: Enables viewing, creating and editing files
///   - `bash`: Enables executing bash commands
/// - Custom tools:
///   - `function`: Represents user-defined custom tools
///
/// Example usage:
/// ```swift
/// let computerTool = Tool.computer(ComputerTool(
///     name: "computer",
///     displayWidthPx: 1024,
///     displayHeightPx: 768,
///     displayNumber: 1
/// ))
///
/// let textEditorTool = Tool.textEditor(TextEditorTool(
///     name: "str_replace_editor"
/// ))
///
/// let bashTool = Tool.bash(BashTool(
///     name: "bash"
/// ))
///
/// let weatherTool = Tool.function(FunctionTool(
///     name: "get_weather",
///     description: "Get the current weather in a given location",
///     inputSchema: weatherSchema
/// ))
/// ```
///
/// - Note: When using Anthropic-defined tools (`computer`, `textEditor`, `bash`),
/// the `description` and `tool_schema` fields are not necessary or allowed.
/// These tools must be explicitly executed by the user and the results returned to Claude.
public enum Tool {
    /// A tool that enables Claude to interact with a computer desktop environment.
    case computer(ComputerTool)

    /// A tool for viewing, creating and editing files.
    case textEditor(TextEditorTool)

    /// A tool for running commands in a bash shell.
    case bash(BashTool)

    /// A tool that represents a custom function that Claude can call.
    case function(FunctionTool)
}

extension Tool: Encodable {
    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .computer(let tool):
            try tool.encode(to: encoder)
        case .textEditor(let tool):
            try tool.encode(to: encoder)
        case .bash(let tool):
            try tool.encode(to: encoder)
        case .function(let tool):
            try tool.encode(to: encoder)
        }
    }
}
