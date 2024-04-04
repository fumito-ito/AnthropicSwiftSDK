//
//  AnthropicVersion.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public enum AnthropicVersion {
    // swiftlint:disable:next identifier_name
    case v2023_06_01
    case custom(String)
}

extension AnthropicVersion {
    public var stringfy: String {
        switch self {
        case .v2023_06_01:
            return "2023-06-01"
        case let .custom(version):
            return version
        }
    }
}
