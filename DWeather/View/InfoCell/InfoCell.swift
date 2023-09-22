//
//  InfoCell.swift
//  DWeather
//
//  Created by woong on 2023/09/22.
//

import UIKit

class InfoCell: UITableViewCell {

    var weatherData: WeatherData?
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithIndexPathRow(indexPathRow: Int) {
        
        switch indexPathRow {
        case 0:
            self.catLabel.text = "일출"
            self.infoLabel.text = Date(timeIntervalSince1970: self.weatherData?.current.sunrise ?? 0).getAmPmFromDate() + " " + Date(timeIntervalSince1970: weatherData?.current.sunrise ?? 0).getHourMinuteFromDate()
           
        case 1:
            self.catLabel.text = "일몰"
            self.infoLabel.text = Date(timeIntervalSince1970: self.weatherData?.current.sunset ?? 0).getAmPmFromDate() + " " + Date(timeIntervalSince1970: weatherData?.current.sunset ?? 0).getHourMinuteFromDate()
            
        case 2:
            self.catLabel.text = "체감 기온"
            self.infoLabel.text = String(format: "%.f", self.weatherData?.current.feels_like ?? 0) + "℃"
        case 3:
            self.catLabel.text = "습도"
            self.infoLabel.text = String(format: "%.f", self.weatherData?.current.humidity ?? 0) + "%"
        case 4:
            self.catLabel.text = "기압"
            self.infoLabel.text = String(format: "%.f", self.weatherData?.current.pressure ?? 0) + " hPa"
        case 5:
            self.catLabel.text = "자외선 지수"
            self.infoLabel.text = String(format: "%.f", self.weatherData?.current.uvi ?? 0)
        case 6:
            self.catLabel.text = "풍속"
            self.infoLabel.text = String(format: "%.f", self.weatherData?.current.wind_speed ?? 0)
        case 7:
            self.catLabel.text = "풍향"
            self.infoLabel.text = String(format: "%.f", self.weatherData?.current.wind_deg ?? 0)
        default :
            print("default")
        }
    }
    
    
}
