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
    func handleLoadingIndicator(show: Bool)
    func didGetWeatherData(currentWeather: CurrentWeather)
    func didGetDailyWeather(dailyWeather: DailyWeather)
    func didWeatherViewModelFail(type: WeatherViewModelErrorType, error: Error)
    
}
class WeatherViewModel:NSObject {
    
    weak var delegate: WeatherViewModelDelegate?
    var currentWeather: CurrentWeather?
    var dailyWeather: DailyWeather?
    var locationManager = CLLocationManager.init()
    var reachability = NetworkReachability.init()
    var location: CLLocation? {
        didSet {
            if let location = location {
                getWeatherData(location: location)
            }
        }
    }
    override init() {
        super.init()
        locationManager.delegate = self

    }
    
    private let dispatchGroup = DispatchGroup.init()
    func getWeatherData(location: CLLocation) {
        if !reachability.isNetworkAvailable() {
            let error = NSError(domain: "", code: 502, userInfo: [NSLocalizedDescriptionKey : "No internet connection"])
            self.delegate?.didWeatherViewModelFail(type: .notInternet, error: error)
            return
        }
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        self.delegate?.handleLoadingIndicator(show: true)
        dispatchGroup.enter()
        WeatherService.shared.getCurrentWeather(lat: lat, long: long) { [weak self] result in
            self?.dispatchGroup.leave()
            switch result {
            case .success(let weather):
                self?.currentWeather = weather
                self?.delegate?.didGetWeatherData(currentWeather: weather)
            case .failure(let error):
                self?.delegate?.didWeatherViewModelFail(type: .currentWeather, error: error)
                print(error.localizedDescription)
            }
        }
        self.dispatchGroup.enter()
        WeatherService.shared.getDailyWeather(lat: lat, long: long, completion: { [weak self] result in
            self?.dispatchGroup.leave()
            switch result {
            case .success(let weather):
                self?.dailyWeather = weather
                self?.delegate?.didGetDailyWeather(dailyWeather: weather)
            case .failure(let error):
                self?.delegate?.didWeatherViewModelFail(type: .dailyWeather, error: error)
                print(error.localizedDescription)
            }
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.delegate?.handleLoadingIndicator(show: false)
        }
        
    }
    func dateFormater(date: TimeInterval, dateFormat: String) -> String {
        let dateText = Date(timeIntervalSince1970: date )
        let formater = DateFormatter()
        formater.timeZone = TimeZone(secondsFromGMT: currentWeather?.timezone ?? 0)
        formater.dateFormat = dateFormat
        return formater.string(from: dateText)
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
            self.location = currentLocation
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        if manager.authorizationStatus == .denied {
            self.delegate?.userDeniedLocationAccess()
            print("User denied the location service")
        }
    }
}





