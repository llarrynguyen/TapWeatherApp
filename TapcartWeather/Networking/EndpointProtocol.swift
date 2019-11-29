//
//  EndpointProtocol.swift
//  TapcartWeather
//
//  Created by Larry Nguyen on 11/22/19.
//  Copyright © 2019 jhall. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

protocol EndpointProtocol {
    var baseUrl : String { get }
    var path: String { get }
    var httpMethod : HTTPMethod { get }
    var parameters : [URLQueryItem]? { get }
    var request: URLRequest? { get }
    var headers: HTTPHeaders? { get}
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case post = "POST"
}

enum Domain: String {
    case openWeather = "https://api.openweathermap.org"
}
