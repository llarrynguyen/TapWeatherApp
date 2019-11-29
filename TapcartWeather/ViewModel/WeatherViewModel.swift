//
//  ViewModel.swift
//  TapcartWeather
//
//  Created by Larry Nguyen on 11/22/19.
//  Copyright © 2019 jhall. All rights reserved.
//

import Foundation

class WeatherViewModel {
    let apiClient: APIClient
    var forecasts: [Forecast] = []
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getWeather(query: String, completion: @escaping (Weather?) -> ()) {
        apiClient.fetchData(endpoint: WeatherEndpoint.getWeather(query: query)) { (weatherResult: WeatherResult?) in
            if let weatherResult = weatherResult {
                let weather = Weather(weatherResult: weatherResult)
                completion(weather)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchForecasts(query: String, completion: @escaping ([Forecast]) -> ()) {
        apiClient.fetchData(endpoint: WeatherEndpoint.getForecast(query: query)) {[weak self] (forecastResult: ForecastResult?) in
            guard let strongSelf = self else {return}
            if forecastResult == nil {
                completion([])
            }
            
            guard let forecastResult = forecastResult else {
                completion([])
                return
            }
            let forcastResultsDict = strongSelf.forcastResultsDict(list: forecastResult.list)
            var forecastDayResults = forcastResultsDict.compactMap {
                WeatherViewModel.oneForecast($0.value)
            }
            forecastDayResults = forecastDayResults.sorted { $0.strimDtText < $1.strimDtText }
            let forecasts = forecastDayResults.map { Forecast(forecastDayResult: $0) }
            strongSelf.forecasts = forecasts
            completion(forecasts)
        }
    }
}

extension WeatherViewModel {
      func forcastResultsDict(list: [ForecastDayResult]) -> [String: [ForecastDayResult]] {
           var dayList = [String: [ForecastDayResult]]()
           list.forEach {
               let day = $0.strimDtText
               if dayList[day] == nil {
                   dayList[day] = [ForecastDayResult]()
               }
               dayList[day]?.append($0)
           }
           return dayList
       }

       static func oneForecast(_ days: [ForecastDayResult]) -> ForecastDayResult? {
           guard var firstDay = days.first else {
               return nil
           }
           var tempMin = firstDay.main.tempMin
           var tempMax = firstDay.main.tempMax
           days.forEach {
               tempMin = min(tempMin, $0.main.tempMin)
               tempMax = max(tempMax, $0.main.tempMax)
           }
           firstDay.main.tempMin = tempMin - 273.15
           firstDay.main.tempMax = tempMax - 273.15
           return firstDay
       }
}

