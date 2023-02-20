//
//  WeatherService.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 19/02/23.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case decodingError
}
class WeatherService {
    
    static let shared = WeatherService()
    private let key = "1c2ba745810db56a9f945361a2520a0a"
    private init() {
        
    }
    
    func getCurrentWeather(lat:Double,long:Double,completion: @escaping (Result<CurrentWeather,NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=metric&appid=\(key)") else {
            completion(.failure(.serverError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let weather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func getDailyWeather(lat:Double,long:Double, completion: @escaping (Result<DailyWeather,NetworkError>) -> ()) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&units=metric&appid=1c2ba745810db56a9f945361a2520a0a") else {
            completion(.failure(.serverError))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let weather = try JSONDecoder().decode(DailyWeather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
}
