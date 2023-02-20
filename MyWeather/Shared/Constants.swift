//
//  Constants.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 19/02/23.
//

import Foundation

struct Constants {
    static let openWeatherApiKey = "9f242b55164c9635bd3f86ffd8a6c0d6"
    
}
//https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=9f242b55164c9635bd3f86ffd8a6c0d6
//https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=9f242b55164c9635bd3f86ffd8a6c0d6
//https://api.openweathermap.org/data/2.5/onecall?lat=53.9024716&lon=27.5618225&exclude=minutely&units=metric&appid=1c2ba745810db56a9f945361a2520a0a

struct APIPath {
    static let currentWeather = "https://api.openweathermap.org/data/2.5/forecast"
    static let fiveDayForcast = "https://api.openweathermap.org/data/2.5/forecast"
    static let oneCall = "https://api.openweathermap.org/data/2.5/onecall"

}
