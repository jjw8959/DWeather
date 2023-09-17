//
//  NetworkManager.swift
//  DWeather
//
//  Created by woong on 2023/09/17.
//

import Foundation



protocol WeatherManagerDelegate {
    func reloadWeatherData()
}


struct NetworkManager {
    
    var delegate: WeatherManagerDelegate?
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                }
                if let safeData = data {
                    ViewController.weatherData = parseJSON(data: safeData)
                    
                    DispatchQueue.main.async {
                        self.delegate?.reloadWeatherData()
                        

                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
}
