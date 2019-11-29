//
//  WeatherCell.swift
//  TapcartWeather
//
//  Created by Larry Nguyen on 11/22/19.
//  Copyright © 2019 jhall. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    static let id = "WeatherCell"
    @IBOutlet weak var dayLabel: UILabel!
    
   @IBOutlet weak var iconImageView: UIImageView!
   @IBOutlet weak var minTempLabel: UILabel!
   @IBOutlet weak var maxTempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 2
        
    }
    
   func updateCell(forecast: Forecast) {
        dayLabel.text = forecast.dayOfTheWeek
        iconImageView.image = UIImage(named:forecast.imageName)
        minTempLabel.text = "\(forecast.minTemperature.formatAsCDegree)"
        maxTempLabel.text = "\(forecast.maxTemperature.formatAsCDegree)"
   }

}
