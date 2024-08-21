//
//  FunctionTools.swift
//  Example
//
//  Created by 伊藤史 on 2024/07/23.
//

import Foundation
import FunctionCalling

@FunctionCalling(service: .claude)
struct FunctionTools {
    /// Returns the temperature at the location specified by the argument, together with the units.
    /// - Parameter location: location to specify the temperature
    /// - Returns: the temperature at the location
    @CallableFunction
    func getWeather(location: String) -> String {
        return "32 Celsius"
    }
}
