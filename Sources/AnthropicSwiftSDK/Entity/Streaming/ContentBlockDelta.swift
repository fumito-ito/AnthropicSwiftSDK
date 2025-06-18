//
//  ContentBlockDelta.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public struct ContentBlockDelta: Decodable, Sendable {
    public let type: ContentBlockDeltaType
    public let text: String?
    public let partialJson: String?
}
