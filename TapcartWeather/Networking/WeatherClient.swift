//
//  WeatherClient.swift
//  TapcartWeather
//
//  Created by Larry Nguyen on 11/22/19.
//  Copyright © 2019 jhall. All rights reserved.
//

import Foundation

enum WeatherEndpoint {
    case getWeather(query: String)
    case getForecast(query: String)
    static let apiKey = "bce770eb36db43822638d40e9733ffe3"
}

extension WeatherEndpoint : EndpointProtocol {
    var baseUrl: String {
        return Domain.openWeather.rawValue
    }
    
    var path: String {
        switch self {
           case .getWeather:
                return "/data/2.5/weather"
           case .getForecast:
                return "/data/2.5/forecast"
           }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getWeather:
            return .get
        case .getForecast:
            return .get
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getWeather( let query):
            return [
                URLQueryItem(name: "APPID", value: WeatherEndpoint.apiKey),
                URLQueryItem(name: "q", value: "\(query)")
            ]
        case .getForecast( let query):
            return [
                URLQueryItem(name: "APPID", value: WeatherEndpoint.apiKey),
                URLQueryItem(name: "q", value: "\(query)")
            ]
        }
    }
    
    var request: URLRequest? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        urlComponents?.queryItems = parameters
        if let url = urlComponents?.url {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            request.allHTTPHeaderFields = headers
            return request
        }
        return nil
    }
    
    var headers: HTTPHeaders? {
        return [
            "Content-Type" : "application/json"
        ]
    }
}
