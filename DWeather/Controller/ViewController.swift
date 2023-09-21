//
//  ViewController.swift
//  DWeather
//
//  Created by woong on 2023/09/17.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    //MARK: - property
    let testURL = "https://api.openweathermap.org/data/3.0/onecall?&lat=37.67&lon=126.80&appid=3de3162e2a95cb6050fc726bf76c691d&units=metric&exclude=minutely"
    
    static var weatherData: WeatherData?
    var networkManager = NetworkManager()
    let locationManager = CLLocationManager()
    
    let findLocation = CLLocation(latitude: 37.6, longitude: 126.7)
    let geocoder = CLGeocoder()
    let locale = Locale(identifier: "Ko-kr")
    var location: [String] = []
    let hourlyTableViewCell = HourlyTableViewCell()
    
    
    //MARK: - outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempertureLabel: UILabel!
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        initLocationManager(locationManager: locationManager)
        locationManager.requestLocation()
        
        
        let hourlyCellNib = UINib(nibName: "HourlyTableViewCell", bundle: nil)
        tableView.register(hourlyCellNib, forCellReuseIdentifier: "HourlyTableViewCell")
        
        let dailyCellNib = UINib(nibName: "DailyCell", bundle: nil)
        tableView.register(dailyCellNib, forCellReuseIdentifier: "DailyCell")
        
        networkManager.delegate = self
        networkManager.performRequest(urlString: testURL)
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 7
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyTableViewCell", for: indexPath) as! HourlyTableViewCell
            
            cell.weatherData = ViewController.weatherData
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyCell
            
            
            cell.dayLabel.text = Date(timeIntervalSince1970: (ViewController.weatherData?.daily[indexPath.row + 1].dt ?? 0) + (ViewController.weatherData?.timezone_offset ?? 0)).getDayFromDate()
            
            cell.lowLabel.text = String(format: "%.0f", floor(ViewController.weatherData?.daily[indexPath.row + 1].temp.min ?? 0)) + "℃"
            
            cell.highLabel.text = String(format: "%.f", floor(ViewController.weatherData?.daily[indexPath.row + 1].temp.max ?? 0)) + "℃"
            
            
            return cell
            
        case 2:
            return UITableViewCell()
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return CGFloat(120)
        case 1:
            return CGFloat(44)
        case 2:
            return CGFloat(44)
        default:
            return CGFloat()
        }
    }
    
}

//MARK: - CLLocationManager

extension ViewController: CLLocationManagerDelegate {
    
    func initLocationManager(locationManager: CLLocationManager) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManagerDidChangeAuthorization(locationManager)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        } else {
            print("위치 off")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위도:\(location.coordinate.latitude)")
            print("경도:\(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate {
    
    func reloadWeatherData() {
        self.tableView.reloadData()
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) {(placemaker, error) in
            if let address: [CLPlacemark] = placemaker {
                if let name: String = address.last?.name {
                    self.location = name.split(separator: " ").map(String.init)
                    self.cityLabel.text = self.location[0]
                }
            }
        }
        
        self.tempertureLabel.text = String(format: "%.f", floor(ViewController.weatherData?.current.temp ?? 0)) + "℃"
        
        self.highLabel.text = "최고: " + String(format: "%.f", floor(ViewController.weatherData?.daily[0].temp.max ?? 0)) + "℃"
        
        self.lowLabel.text = "최소: " + String(format: "%.f", floor(ViewController.weatherData?.daily[0].temp.min ?? 0)) + "℃"
        
//        hourlyTableViewCell.collectionView.reloadData()
        
    }
    
}

//MARK: - ETC.
//
//extension ViewController {
//
//}


extension Date {
    
    func getAmPmFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter.string(from: self)
    }
    
    func getHourFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        return formatter.string(from: self)
    }
    
    func getDayFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}
