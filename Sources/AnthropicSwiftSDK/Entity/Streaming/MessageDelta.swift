//
//  MessageDelta.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public struct MessageDelta: Decodable {
    public let stopReason: StopReason
    public let stopSequence: String?
}
