//
//  DailyCell.swift
//  DWeather
//
//  Created by woong on 2023/09/17.
//

import UIKit
import Kingfisher

struct DailyData {
    let dayString: String?
    let lowString: String?
    let highString: String?
    let urlString: String?
}

class DailyCell: UITableViewCell {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    var weatherData: WeatherData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - DailyCell funcs
    
    func getData(weatherData: WeatherData?) {
        self.weatherData = weatherData
    }
    
    func configureCell(index: Int) -> DailyData {
        var dayString: String?
        var lowString: String?
        var highString: String?
        var urlString: String?
        
        if let weatherData = weatherData {
            let dailyData = weatherData.daily[index]
            dayString = Date(timeIntervalSince1970: (dailyData.dt) + (self.weatherData?.timezone_offset ?? 0)).getDayFromDate()
            lowString = String(format: "%.f", dailyData.temp.min)
            highString = String(format: "%.f", dailyData.temp.max)
            urlString = "https://openweathermap.org/img/wn/\(dailyData.weather[0].icon)@2x.png"
        }
        
        return DailyData(dayString: dayString, lowString: lowString, highString: highString, urlString: urlString)
    }
    
    func setupCell(_ dailyData: DailyData) {
        self.dayLabel.text = dailyData.dayString
        self.lowLabel.text = dailyData.lowString
        self.lowLabel.text?.append("℃")
        self.highLabel.text = dailyData.highString
        self.highLabel.text?.append("℃")
        
        if let urlString = dailyData.urlString, let url = URL(string: urlString){
            self.weatherImage.kf.setImage(with: url)
        }
        
    }
    
}
