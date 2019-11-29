//
//  Forcecast.swift
//  TapcartWeather
//
//  Created by Justin Hall on 1/31/19.
//  Copyright © 2019 jhall. All rights reserved.
//

import Foundation

struct ForecastResult: Decodable {
    let list: [ForecastDayResult]
}

struct ForecastDayResult: Decodable {
    var weather: [WeatherType]
    var main: WeatherMain
    var dtTxt: String
}

extension ForecastDayResult {
    var strimDtText: String {
        return String(dtTxt.dropLast(dtTxt.count - 10))
    }
}

struct Forecast {
    var dayOfTheWeek:   String
    var minTemperature: Double
    var maxTemperature: Double
    var imageName:      String
    
    init(forecastDayResult: ForecastDayResult) {
        let date = Forecast.dateFormatter.date(from: forecastDayResult.strimDtText) ?? Date()
        dayOfTheWeek = Forecast.dayOfWeekFormatter.string(from: date)
        minTemperature = forecastDayResult.main.tempMin
        maxTemperature = forecastDayResult.main.tempMax
        imageName = forecastDayResult.weather.first?.main ?? ""
    }
}

extension Forecast {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static var dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
}
