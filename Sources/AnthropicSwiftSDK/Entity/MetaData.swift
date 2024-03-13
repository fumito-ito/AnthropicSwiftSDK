//
//  MetaData.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// An object describing metadata about the request.
public struct MetaData {
    /// An external identifier for the user who is associated with the request.
    ///
    /// This should be a uuid, hash value, or other opaque identifier. Anthropic may use this id to help detect abuse. Do not include any identifying information such as name, email address, or phone number.
    public let userId: String
}

extension MetaData: Encodable {}
