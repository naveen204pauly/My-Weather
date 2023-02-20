//
//  ViewController.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 18/02/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var hourlyForecaseCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension ViewController: WeatherViewModelDelegate {
    func userDeniedLocationAccess() {
        let alert = UIAlertController(title: "Access Denied", message: "Location serview is required to get your current location weather", preferredStyle: .alert)
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
        
    }
    
    func didGetDailyWeather(dailyWeather: DailyWeather) {
        
    }
    
    func didWeatherViewModelFail(type: WeatherViewModelErrorType, error: Error) {
        
    }
    
    
}
