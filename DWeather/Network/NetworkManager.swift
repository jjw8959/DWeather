//
//  NetworkManager.swift
//  DWeather
//
//  Created by woong on 2023/09/17.
//

import Foundation



//protocol WeatherManagerDelegate {
//    func reloadWeatherData()
//}


struct NetworkManager {
//
//    var delegate: WeatherManagerDelegate?
    
    func performRequest(urlString: String, completion: @escaping (WeatherData?) -> Void) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        completion(weatherData)
                    }
                } catch let jsonError {
                    print("Failed to decode from JSON", jsonError)
                }
                
            }.resume()
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
