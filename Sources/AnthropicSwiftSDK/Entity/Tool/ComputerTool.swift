//
//  ComputerTool.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/29.
//

/// A tool that enables Claude to interact with a computer desktop environment.
///
/// This is one of the Anthropic-defined tools that allows Claude to control a computer display.
/// When specifying this tool, `description` and `tool_schema` fields are not necessary or allowed.
///
/// Example usage:
/// ```swift
/// let computerTool = ComputerTool(
///     name: "computer",
///     displayWidthPx: 1024,
///     displayHeightPx: 768,
///     displayNumber: 1
/// )
/// ```
///
/// - Note: It is not recommended to send screenshots in resolutions above XGA/WXGA to avoid issues related to image resizing.
/// Relying on the image resizing behavior in the API will result in lower model accuracy and slower performance
/// than directly implementing scaling yourself.
public struct ComputerTool {
    /// The version identifier for the computer tool.
    ///
    /// Currently supports:
    /// - `computer_20241022`: The initial version of the computer tool
    public enum ComputerType: String, RawRepresentable, Encodable {
        /// The initial version of the computer tool released on October 22, 2024
        case computer20241022 = "computer_20241022"
    }

    /// The type identifier for the tool. Used for validation purposes.
    public let type: ComputerType

    /// The name of the tool that will be exposed to the model.
    ///
    /// - Note: The name must be unique within the tool list in an API call.
    /// While you can define a tool with a different name, using "computer" is recommended
    /// as it may result in better model performance.
    public let name: String

    /// The width of the display being controlled by the model in pixels.
    ///
    /// - Note: It is recommended to use XGA/WXGA or lower resolutions for optimal performance.
    public let displayWidthPx: Int

    /// The height of the display being controlled by the model in pixels.
    ///
    /// - Note: It is recommended to use XGA/WXGA or lower resolutions for optimal performance.
    public let displayHeightPx: Int

    /// The display number to control (only relevant for X11 environments).
    public let displayNumber: Int

    /// Creates a new computer tool instance.
    /// - Parameters:
    ///   - type: The version of the computer tool to use. Defaults to `.computer20241022`.
    ///   - name: The name of the tool that will be exposed to the model.
    ///   - displayWidthPx: The width of the display in pixels.
    ///   - displayHeightPx: The height of the display in pixels.
    ///   - displayNumber: The display number to control (for X11 environments).
    public init(
        type: ComputerType = .computer20241022,
        name: String,
        displayWidthPx: Int,
        displayHeightPx: Int,
        displayNumber: Int
    ) {
        self.type = type
        self.name = name
        self.displayWidthPx = displayWidthPx
        self.displayHeightPx = displayHeightPx
        self.displayNumber = displayNumber
    }
}

extension ComputerTool: Encodable {}
