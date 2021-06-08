//
//  WeatherReslut.swift
//  WeatherApp_withRx
//
//  Created by 최강훈 on 2021/06/08.
//

import Foundation

struct WeatherResult: Codable {
    let main: Weather
}

struct Weather: Codable {
    let temp: Double
    let humidity: Double
}

extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}
