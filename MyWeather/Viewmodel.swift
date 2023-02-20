//
//  Viewmodel.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 20/02/23.
//

import Foundation
import CoreLocation
import Network

enum WeatherViewModelErrorType {
    case currentWeather, dailyWeather, notInternet
}
protocol WeatherViewModelDelegate: AnyObject {
    func userDeniedLocationAccess()
    func didGetWeatherData(currentWeather: CurrentWeather)
    func didGetDailyWeather(dailyWeather: DailyWeather)
    func didWeatherViewModelFail(type: WeatherViewModelErrorType, error: Error)
    
}
class WeatherViewModel:NSObject {
    
    weak var delegate: WeatherViewModelDelegate?
    var currentWeather: CurrentWeather?
    var dailyWeather: DailyWeather?
    var locationManager = CLLocationManager.init()
    var location: CLLocation? {
        didSet {
            if let location = location {
                getWeatherData(location: location)
            }
        }
    }
    
    convenience init(delegate: WeatherViewModelDelegate) {
        self.init()
        locationManager.delegate = self
        self.delegate = delegate
    }
    
    
    private func getWeatherData(location: CLLocation) {
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        WeatherService.shared.getCurrentWeather(lat: lat, long: long) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.currentWeather = weather
                self?.delegate?.didGetWeatherData(currentWeather: weather)
            case .failure(let error):
                self?.delegate?.didWeatherViewModelFail(type: .currentWeather, error: error)
                print(error.localizedDescription)
            }
        }
        WeatherService.shared.getDailyWeather(lat: lat, long: long, completion: { [weak self] result in
            switch result {
            case .success(let weather):
                self?.dailyWeather = weather
                self?.delegate?.didGetDailyWeather(dailyWeather: weather)
            case .failure(let error):
                self?.delegate?.didWeatherViewModelFail(type: .dailyWeather, error: error)
                print(error.localizedDescription)
            }
        })
        
    }
}

// MARK: - Core location delegate.
extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined {
            manager.requestAlwaysAuthorization()
        }
        if (manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways) {
            guard let currentLocation = manager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        if manager.authorizationStatus == .denied {
            self.delegate?.userDeniedLocationAccess()
            print("User denied the location service")
        }
    }
}





