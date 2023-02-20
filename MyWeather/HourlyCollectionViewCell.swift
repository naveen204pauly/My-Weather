//
//  HourlyCollectionViewCell.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 20/02/23.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourlyImageVew: UIImageView!
    @IBOutlet weak var hourlyTemp: UILabel!
    @IBOutlet weak var hourlyTime: UILabel!
    
    func configure(hourly: Hourly, indexPath: Int) {
        hourlyImageVew.contentMode = .scaleAspectFit
        hourlyImageVew.image = UIImage(named: "\(hourly.weather.first!.icon)-1.png")
        hourlyTemp.text = "\(hourly.temp.doubleToString())°"
    }
}
