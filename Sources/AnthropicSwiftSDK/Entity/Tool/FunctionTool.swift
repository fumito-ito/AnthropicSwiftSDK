//
//  FunctionTool.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/29.
//

/// A tool that represents a custom function that Claude can call.
///
/// This is used to define custom tools that Claude can use to perform specific tasks.
/// Each tool must have a unique name, a detailed description of its functionality,
/// and a schema defining its input parameters.
///
/// Example usage:
/// ```swift
/// let weatherSchema = InputSchema(
///     type: .object,
///     format: nil,
///     description: "Weather query parameters",
///     nullable: nil,
///     enumValues: nil,
///     items: nil,
///     properties: [
///         "location": InputSchema(
///             type: .string,
///             format: nil,
///             description: "The city and state, e.g. San Francisco, CA",
///             nullable: nil,
///             enumValues: nil,
///             items: nil,
///             properties: nil,
///             requiredProperties: nil
///         )
///     ],
///     requiredProperties: ["location"]
/// )
///
/// let weatherTool = FunctionTool(
///     name: "get_weather",
///     description: "Get the current weather in a given location",
///     inputSchema: weatherSchema
/// )
/// ```
public struct FunctionTool {
    /// The name of the tool that will be exposed to the model.
    ///
    /// - Note: The name must be unique within the tool list in an API call and
    /// match the regex pattern `^[a-zA-Z0-9_-]{1,64}$`.
    public let name: String

    /// A detailed description of what the tool does, when it should be used, and how it behaves.
    ///
    /// - Note: The description should be as detailed as possible to help Claude understand
    /// when and how to use the tool effectively.
    public let description: String

    /// A JSON Schema object defining the expected parameters for the tool.
    public let inputSchema: InputSchema

    /// Creates a new function tool instance.
    /// - Parameters:
    ///   - name: The name of the tool that will be exposed to the model.
    ///   - description: A detailed description of the tool's functionality.
    ///   - inputSchema: The schema defining the tool's input parameters.
    public init(name: String, description: String, inputSchema: InputSchema) {
        self.name = name
        self.description = description
        self.inputSchema = inputSchema
    }
}

extension FunctionTool: Encodable {}

/// A class representing the JSON Schema for a tool's input parameters.
///
/// This class is used to define the structure and validation rules for a tool's input.
/// It supports nested schemas and various data types.
public class InputSchema {
    /// The type of value that the schema represents.
    public enum SchemaType: String, Encodable {
        /// A text string
        case string
        /// A numeric value that can include decimals
        case number
        /// A whole number
        case integer
        /// A true/false value
        case boolean
        /// A list of values
        case array
        /// A complex object with properties
        case object
    }

    /// The type of value this schema represents
    public let type: SchemaType

    /// Optional format specifier for the value (e.g., "date-time", "email", etc.)
    public let format: String?

    /// Description of what this schema parameter represents
    public let description: String

    /// Whether this value can be null
    public let nullable: Bool?

    /// For string types, an array of allowed values
    public let enumValues: [String]?

    /// For array types, the schema for array items
    public let items: InputSchema?

    /// For object types, a map of property names to their schemas
    public let properties: [String: InputSchema]?

    /// For object types, an array of required property names
    public let requiredProperties: [String]?

    /// Creates a new input schema instance.
    /// - Parameters:
    ///   - type: The type of value this schema represents
    ///   - format: Optional format specifier
    ///   - description: Description of what this parameter represents
    ///   - nullable: Whether this value can be null
    ///   - enumValues: For string types, an array of allowed values
    ///   - items: For array types, the schema for array items
    ///   - properties: For object types, a map of property names to their schemas
    ///   - requiredProperties: For object types, an array of required property names
    public init(
        type: SchemaType,
        format: String?,
        description: String,
        nullable: Bool?,
        enumValues: [String]?,
        items: InputSchema?,
        properties: [String: InputSchema]?,
        requiredProperties: [String]?
    ) {
        self.type = type
        self.format = format
        self.description = description
        self.nullable = nullable
        self.enumValues = enumValues
        self.items = items
        self.properties = properties
        self.requiredProperties = requiredProperties
    }
}

extension InputSchema: Encodable {
    enum CodingKeys: String, CodingKey {
        case type
        case format
        case description
        case nullable
        case enumValues = "enum"
        case items
        case properties
        case requiredProperties = "required"
    }
}
