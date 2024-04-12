//
//  SupportedRegion.swift
//  
//
//  Created by 伊藤史 on 2024/04/04.
//

import Foundation

/// The regions now supports Anthropic API on VertexAI
public enum SupportedRegion: String {
    /// us-central1 region
    case usCentral1 = "us-central1"
    /// asia-southeast1 region
    ///
    /// This region supports only Claude 3 Sonnet
    case asiaSouthEast1 = "asia-southeast1"
    /// europe-west4 region
    ///
    /// This region supports only Claude 3 Haiku
    case europeWest4 = "europe-west4"
}
