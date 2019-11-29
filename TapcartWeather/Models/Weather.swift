//
//  Weather.swift
//  TapcartWeather
//
//  Created by Larry Nguyen on 11/22/19.
//  Copyright © 2019 jhall. All rights reserved.
//

import UIKit
import Foundation
struct WeatherResult: Decodable {
    var weather: [WeatherType]
    var main: WeatherMain
    var name: String
}

struct WeatherType: Decodable {
    var main: String
}

struct WeatherMain: Decodable {
    var temp: Double
    var tempMin: Double
    var tempMax: Double
}

struct Weather {
    var location: String
    var temp: Double
    var imageName: String
    
    init(weatherResult: WeatherResult) {
        location = weatherResult.name
        temp = weatherResult.main.temp - 273.15
        imageName = weatherResult.weather.first?.main ?? ""
    }
}

extension Weather {
    var headerColor: UIColor? {
        switch temp {
        case -Double.infinity..<15:
            return UIColor(named: "headerPurple")
        case 15...25:
             return UIColor(named: "headerCream")
        default:
            return UIColor(named: "headerPink")
        }
    }
}
