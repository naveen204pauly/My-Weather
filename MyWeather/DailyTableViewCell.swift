//
//  DailyTableViewCell.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 20/02/23.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var dailyImage: UIImageView!
    @IBOutlet weak var dailyDate: UILabel!
    @IBOutlet weak var dailyMaxTemp: UILabel!
    @IBOutlet weak var dailyMinTemp: UILabel!
    
    func configure(daily: Daily, indexPath: Int) {
        dailyImage.image = UIImage(named: "\(daily.weather.first!.icon)-1.png")
        dailyMinTemp.text = "L: \(daily.temp.min.doubleToString())°"
        dailyMaxTemp.text = "H: \(daily.temp.max.doubleToString())°"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
