//
//  BashTool.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/29.
//

/// A tool for running commands in a bash shell.
///
/// This is one of the Anthropic-defined tools that enables Claude to execute bash commands.
/// When specifying this tool, `description` and `tool_schema` fields are not necessary or allowed.
///
/// Example usage:
/// ```swift
/// let bashTool = BashTool(name: "bash")
/// ```
public struct BashTool {
    /// The version identifier for the bash tool.
    ///
    /// Currently supports:
    /// - `bash_20241022`: The initial version of the bash tool
    public enum BashType: String, RawRepresentable, Encodable {
        /// The initial version of the bash tool released on October 22, 2024
        case bash20241022 = "bash_20241022"
    }

    /// The type identifier for the tool. Used for validation purposes.
    public let type: BashType

    /// The name of the tool that will be exposed to the model.
    ///
    /// - Note: The name must be unique within the tool list in an API call.
    /// While you can define a tool with a different name, using "bash" is recommended
    /// as it may result in better model performance.
    public let name: String

    /// Creates a new bash tool instance.
    /// - Parameters:
    ///   - type: The version of the bash tool to use. Defaults to `.bash20241022`.
    ///   - name: The name of the tool that will be exposed to the model.
    public init(type: BashType = .bash20241022, name: String) {
        self.type = type
        self.name = name
    }
}

extension BashTool: Encodable {}
