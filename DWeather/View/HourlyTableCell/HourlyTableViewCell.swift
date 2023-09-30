//
//  HourlyTableViewCell.swift
//  DWeather
//
//  Created by woong on 2023/09/20.
//

import UIKit
import Kingfisher

class HourlyTableViewCell: UITableViewCell{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var weatherData: WeatherData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.showsHorizontalScrollIndicator = false
        
        let hourlyCellNib = UINib(nibName: "HourlyCell", bundle: nil)
        collectionView.register(hourlyCellNib, forCellWithReuseIdentifier: "HourlyCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.backgroundColor = UIColor.clear
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getData(weatherData: WeatherData?) {
        self.weatherData = weatherData
        print("asfasdfasdfasdfasdfasdf")
        print(weatherData)
        self.collectionView.reloadData()
    }
}

//MARK: - delegateflowlayout

extension HourlyTableViewCell:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 120)
    }
}

//MARK: - datasource, delegate

extension HourlyTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCell
        
        let ampm = Date(timeIntervalSince1970: self.weatherData?.hourly[indexPath.row + 1].dt ?? 0).getAmPmFromDate()
        let hour = Date(timeIntervalSince1970: self.weatherData?.hourly[indexPath.row + 1].dt ?? 0).getHourFromDate()
        cell.tempLabel.text = String(format: "%.f", self.weatherData?.hourly[indexPath.row + 1].temp ?? 0) + "℃"
        
        cell.timeLabel.text = "\(ampm) \(hour)시"
        if let icon = self.weatherData?.hourly[indexPath.row + 1].weather[0].icon,
           let weatherImageURL = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
            cell.weatherImageView.kf.setImage(with: weatherImageURL)
        }


        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
}
