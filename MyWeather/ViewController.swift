//
//  ViewController.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 18/02/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var hourlyForecastCollectionView: UICollectionView!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentWeatherDescription: UILabel!
    @IBOutlet weak var currentMaxTemperature: UILabel!
    @IBOutlet weak var currentMinTemperature: UILabel!
    

    let viewModel = WeatherViewModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForInitialLoad()
    }
    
    
    private func prepareForInitialLoad() {
        viewModel.delegate = self
        self.backgroundImageView.addImageGradient()
        animateBackgroundImage()
    }
    
    private func animateBackgroundImage() {
        self.backgroundImageView.frame.origin.x = 0
        UIView.animate(withDuration: 10, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.backgroundImageView.frame.origin.x -= 100
        }, completion: nil)
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dailyWeather?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HourlyCollectionViewCell
        cell.configure(hourly: viewModel.dailyWeather!.hourly[indexPath.row], indexPath: indexPath.row)
        let date = viewModel.dailyWeather!.hourly[indexPath.row].dt
        cell.hourlyTime.text = viewModel.dateFormater(date: date, dateFormat: "hh:mm a")
        return cell
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dailyWeather?.daily.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DailyTableViewCell
        cell.configure(daily: viewModel.dailyWeather!.daily[indexPath.row], indexPath: indexPath.row)
        let date = viewModel.dailyWeather!.daily[indexPath.row].dt
        cell.dailyDate.text = self.viewModel.dateFormater(date: date, dateFormat: "EEEE")
        return cell
    }
}

extension ViewController: WeatherViewModelDelegate {
    func userDeniedLocationAccess() {
        let alert = UIAlertController(title: "Access Denied", message: "Allow \"My Weather\" to access your location while your are using the app", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Go to settings", style: .default){ action in
            if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            alert.dismiss(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
    
    func didGetWeatherData(currentWeather: CurrentWeather) {
        backgroundImageView.image = UIImage(named: "\(currentWeather.weather.first!.icon)-2.png")
        locationName.text = currentWeather.name
        currentTemperature.text = "\(currentWeather.main.temp.doubleToString())°"
        currentMinTemperature.text = "L: \(currentWeather.main.temp_min.doubleToString())°"
        currentMaxTemperature.text = "H: \(currentWeather.main.temp_max.doubleToString())°"
        currentWeatherDescription.text = currentWeather.weather.first?.description.capitalizedSentence
    }
    
    func didGetDailyWeather(dailyWeather: DailyWeather) {
        self.hourlyForecastCollectionView.reloadData()
        self.dailyForecastTableView.reloadData()
        self.dailyForecastTableView.layoutIfNeeded()
        tableViewHeight.constant = dailyForecastTableView.contentSize.height
        
    }
    
    func didWeatherViewModelFail(type: WeatherViewModelErrorType, error: Error) {
        if type == .notInternet {
            let alert = UIAlertController.init(title: "No internet Conection", message: "You dont have active network connection to make connecttion to server", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Retry", style: .default) { action in
                if let location  = self.viewModel.location {
                    self.viewModel.getWeatherData(location: location)
                }
                alert.dismiss(animated: true)
            })
            self.present(alert, animated: true)
        }
        
    }
    func handleLoadingIndicator(show: Bool) {
        if show {
            self.view.showBlurLoader()
        } else {
            self.view.removeBluerLoader()
        }
    }
    
    
}
