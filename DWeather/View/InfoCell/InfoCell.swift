//
//  InfoCell.swift
//  DWeather
//
//  Created by woong on 2023/09/22.
//

import UIKit

struct InfoData {
    let catString: String?
    let infoString: String?
}

class InfoCell: UITableViewCell {

    var weatherData: WeatherData?
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getData(weatherData: WeatherData?) {
        self.weatherData = weatherData
    }
    
    func configureCell(index: Int) -> InfoData {
        var catString: String?
        var infoString: String?
        
        if let weatherData = weatherData {
            let infoData = weatherData.current
            switch index {
            case 0:
                catString = "일출"
                infoString = Date(timeIntervalSince1970: infoData.sunrise).getAmPmFromDate() + " " + Date(timeIntervalSince1970: infoData.sunrise).getHourMinuteFromDate()
            case 1:
                catString = "일몰"
                infoString = Date(timeIntervalSince1970: infoData.sunset).getAmPmFromDate() + " " + Date(timeIntervalSince1970: infoData.sunset).getHourMinuteFromDate()
            case 2:
                catString = "체감 기온"
                infoString = String(format: "%.f", infoData.feels_like) + "℃"
            case 3:
                catString = "습도"
                infoString = String(format: "%.f", infoData.humidity) + "%"
            case 4:
                catString = "기압"
                infoString = String(format: "%.f", infoData.pressure) + " hPa"
            case 5:
                catString = "자외선 지수"
                infoString = String(format: "%.f", infoData.uvi)
            case 6:
                catString = "풍속"
                infoString = String(format: "%.f", infoData.wind_speed)
            case 7:
                catString = "풍향"
                infoString = String(format: "%.f", infoData.wind_deg)
                
            default:
                print("default")
            }
        }
        return InfoData(catString: catString, infoString: infoString)
        
    }
    
    func setupCell(_ infoData: InfoData) {
        self.catLabel.text = infoData.catString
        self.infoLabel.text = infoData.infoString
        
    }
    
}
