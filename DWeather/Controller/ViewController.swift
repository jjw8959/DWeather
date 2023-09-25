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
   
    var urls = ""
    
    var weatherData: WeatherData?
    var networkManager = NetworkManager()
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let locale = Locale(identifier: "Ko-kr")
    var location: [String] = []
    
    let urlHeader = "https://api.openweathermap.org/data/3.0/onecall?"
    let apiKey = "&appid=3de3162e2a95cb6050fc726bf76c691d"
    let urlTrailer = "&units=metric&exclude=minutely"
    
    //MARK: - outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempertureLabel: UILabel!
    
    @IBAction func updateLocationPressed(_ sender: UIButton) {
        startApplication()
    }
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        initCells()
        startApplication()
        
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

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
            return 8
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyTableViewCell", for: indexPath) as! HourlyTableViewCell
            
            cell.weatherData = self.weatherData
            
            cell.backgroundColor = UIColor.clear
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyCell
            
            cell.getData(weatherData: self.weatherData)
            let configuredData = cell.configureCell(index: indexPath.row + 1)
            cell.setupCell(configuredData)
            
            cell.backgroundColor = UIColor.clear
            
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            
            cell.getData(weatherData: weatherData)
            let configuredData = cell.configureCell(index: indexPath.row)
            cell.setupCell(configuredData)
            
            cell.backgroundColor = UIColor.clear
            
            return cell
            
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
            return CGFloat(75)
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
    
    func changeAddressToDong(foundLocation: CLLocation) {
        geocoder.reverseGeocodeLocation(foundLocation, preferredLocale: locale) {(placemaker, error) in
            if let address: [CLPlacemark] = placemaker {
                if let name = address.last?.name {
                    self.location = name.split(separator: " ").map(String.init)
                    self.cityLabel.text = self.location[0]
                    print(self.location[0])
                    
                }
            }
        }
    }
}


//MARK: - ETC.

extension ViewController {
    func initCells() {
        let hourlyCellNib = UINib(nibName: "HourlyTableViewCell", bundle: nil)
        tableView.register(hourlyCellNib, forCellReuseIdentifier: "HourlyTableViewCell")
        
        let dailyCellNib = UINib(nibName: "DailyCell", bundle: nil)
        tableView.register(dailyCellNib, forCellReuseIdentifier: "DailyCell")
        
        let infoCellNib = UINib(nibName: "InfoCell", bundle: nil)
        tableView.register(infoCellNib, forCellReuseIdentifier: "InfoCell")
    }
    
    func startApplication() {
        initLocationManager(locationManager: locationManager)
        locationManager.requestLocation()
        
        let lat = locationManager.location?.coordinate.latitude ?? 0 //수정필요
        let long = locationManager.location?.coordinate.longitude ?? 0 //수정필요
        let findLocation = CLLocation(latitude: lat, longitude: long)
        print(lat)
        print(long)
        
        urls = urlHeader + "&lat=" + String(format:"%.6f", lat) + "&lon=" + String(format: "%.6f", long) + apiKey + urlTrailer
        
        networkManager.performRequest(urlString: urls) { (weather) in
            guard let weather = weather else { return }
            self.weatherData = weather
            self.reloadWeatherData(foundLocation: findLocation)
        }
    }
    
    func reloadWeatherData(foundLocation: CLLocation) {
        self.tableView.reloadData()
        setCurrentWeatherLabels(foundLocation: foundLocation)
    }
    
    func setCurrentWeatherLabels(foundLocation: CLLocation) {
        self.tempertureLabel.text = String(format: "%.f", floor(self.weatherData?.current.temp ?? 0)) + "℃"
        
        self.highLabel.text = "최고: " + String(format: "%.f", floor(self.weatherData?.daily[0].temp.max ?? 0)) + "℃"
        
        self.lowLabel.text = "최소: " + String(format: "%.f", floor(self.weatherData?.daily[0].temp.min ?? 0)) + "℃"
        
        changeAddressToDong(foundLocation: foundLocation)
    }
}

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
    
    func getHourMinuteFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h시 m분"
        return formatter.string(from: self)
    }
}
