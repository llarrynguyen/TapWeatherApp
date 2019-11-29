//
//  TapcartWeatherTests.swift
//  TapcartWeatherTests
//
//  Created by Larry Nguyen on 11/22/19.
//  Copyright © 2019 jhall. All rights reserved.
//

import XCTest

class TapcartWeatherTests: XCTestCase {
    
    var weatherViewModel = WeatherViewModel(apiClient: APIClient())

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNumberOfForecast() {
        // The number of forcasts cannot be over 5
        XCTAssertLessThanOrEqual(weatherViewModel.forecasts.count, 5, "The number of forcasts cannot be over 5")
        
    }

}
