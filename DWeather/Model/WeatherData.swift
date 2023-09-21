//
//  WeatherData.swift
//  DWeather
//
//  Created by woong on 2023/09/17.
//

import Foundation

struct WeatherData: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    let timezone_offset: Double
}

struct Current: Codable {
    let dt: Double
    let sunrise: Int
    let sunset: Int
    let temp: Float
    let feels_like: Float
    let pressure: Double
    let humidity: Int
    let uvi: Float
    let wind_speed: Float
    let wind_deg: Float
//    let weather: [Weather]
}

struct Hourly: Codable {
    let dt: Double
    let temp: Float
    let weather: [Weather]
}

struct Hour: Codable {
    let dt: Int
    let temp: Float
//    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Double
    let temp: Temp
//    let weather: [Weather]
}

struct Temp: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

