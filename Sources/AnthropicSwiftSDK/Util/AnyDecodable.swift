//
//  AnyDecodable.swift
//  
//
//  Created by 伊藤史 on 2024/07/17.
//

import Foundation

struct AnyCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) { self.stringValue = stringValue }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard contains(key) else { return .none }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try nestedContainer(keyedBy: AnyCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard contains(key) else { return .none }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary: [String: Any] = [:]

        allKeys.forEach { key in
            if (try? decodeNil(forKey: key)) == true {
                dictionary[key.stringValue] = nil
            } else if let value = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = value
            }
        }

        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []

        while isAtEnd == false {
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let value = try? decode(Int64.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode([String: Any].self) {
                array.append(value)
            } else if let value = try? decode([Any].self) {
                array.append(value)
            }
        }

        return array
    }

    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: AnyCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}
