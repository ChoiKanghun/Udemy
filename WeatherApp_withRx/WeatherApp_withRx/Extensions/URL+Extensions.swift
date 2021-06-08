//
//  URL+Extensions.swift
//  WeatherApp_withRx
//
//  Created by 최강훈 on 2021/06/08.
//

import Foundation

extension URL {
    
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=3c0ced3359aa279133f1030343f5bd94&units=metric")
    }
    
}
