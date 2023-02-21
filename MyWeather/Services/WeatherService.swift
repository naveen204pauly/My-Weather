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
    
    //Since Open Weather restrict the number of free API calls, uncomment the below code for getting data from local json file for debugging purposes and comment the URLSession.
    func getCurrentWeather(lat:Double,long:Double,completion: @escaping (Result<CurrentWeather,NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=metric&appid=\(key)") else {
            completion(.failure(.serverError))
            return
        }
        
//        @DecodableJsonFile(name: "CurrentWeather")
//        var jsonData: CurrentWeather?
//        if let data = jsonData {
//            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                completion(.success(data))
//            }
//        } else {
//            completion(.failure(.decodingError))
//        }
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        completion(.failure(.serverError))
                        return
                    }
                    do {
                        let weather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(weather))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(.decodingError))
                        }
                    }
                }.resume()
    }
    
    func getDailyWeather(lat:Double,long:Double, completion: @escaping (Result<DailyWeather,NetworkError>) -> ()) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&units=metric&appid=\(key)") else {
            completion(.failure(.serverError))
            return
        }
        
//        @DecodableJsonFile(name: "DailyWeather")
//        var jsonData: DailyWeather?
//        if let data = jsonData {
//            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                completion(.success(data))
//            }
//        } else {
//            completion(.failure(.decodingError))
//        }
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        completion(.failure(.serverError))
                        return
                    }
                    do {
                        let weather = try JSONDecoder().decode(DailyWeather.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(weather))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(.decodingError))
                        }
        
                    }
                }.resume()
    }
    
    
}


@propertyWrapper struct DecodableJsonFile<T: Decodable> {
    let name: String
    let type: String = "json"
    let bundle: Bundle = .main
    let decoder = JSONDecoder()
    
    var wrappedValue: T? {
        guard let path = bundle.url(forResource: name, withExtension: type),
              let data = try? Data.init(contentsOf: path),
              let jsonData = try? decoder.decode(T.self, from: data)
        else {
            return nil
        }
        return jsonData
    }
}
