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
    
    let testURL = "https://api.openweathermap.org/data/3.0/onecall?&lat=37.67&lon=126.80&appid=3de3162e2a95cb6050fc726bf76c691d&units=metric&exclude=minutley"
    
    static var weatherData: WeatherData?
    var networkManager = NetworkManager()
    let locationManager = CLLocationManager()

    //MARK: - outlet
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        initLocationManager(locationManager: locationManager)
        
        
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
            return UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyCell
            
//            cell.dayLabel.text = String(format: "%.f", (ViewController.weatherData?.daily[indexPath.row + 1].dt ?? 0) + (ViewController.weatherData?.timezone_offset ?? 0) )
            
            cell.dayLabel.text = Date(timeIntervalSince1970: (ViewController.weatherData?.daily[indexPath.row + 1].dt ?? 0) + (ViewController.weatherData?.timezone_offset ?? 0)).getDayFromDate()
//            cell.lowLabel.text = ViewController.weatherData?.daily[indexPath.row + 1].temp[0].min
            
            print
            
            return cell
//            return UITableViewCell()
        case 2:
            return UITableViewCell()
        default:
            return UITableViewCell()
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
    }
    
}


extension Date {
    
    func getDayFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}
