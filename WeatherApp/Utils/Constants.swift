//
//  Constants.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 07.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit


// Enumeration
enum WeatherType {
    case clearDay
    case clearNight
    case cloudy
    case fog
    case hail
    case partlyCloudyDay
    case partlyCloudyNight
    case rain
    case sleet
    case snow
    case thunderstorm
    case tornado
    case wind
    
    static func getWeatherType(type: WeatherType) -> String? {
        switch type {
        case .clearDay:
            return "clear-day"
        case .clearNight:
            return "clear-night"
        case .cloudy:
            return "cloudy"
        case .fog:
            return "fog"
        case .hail:
            return "hail"
        case .partlyCloudyDay:
            return "partly-cloudy-day"
        case .partlyCloudyNight:
            return "partly-cloudy-night"
        case .rain:
            return "rain"
        case .sleet:
            return "sleet"
        case .snow:
            return "snow"
        case .thunderstorm:
            return "thunderstorm"
        case .tornado:
            return "tornado"
        case .wind:
            return "wind"
        }
    }
}

// Array
let headerImageArray: [String] = ["header_image-clear-day", "header_image-clear-night", "header_image-cloudy", "header_image-fog", "header_image-hail", "header_image-partly-cloudy-day", "header_image-partly-cloudy-night", "header_image-rain", "header_image-sleet", "header_image-snow", "header_image-thunderstorm", "header_image-tornado", "header_image-wind"]


let bodyImageArray: [String] = ["body_image-clear-day", "body_image-clear-night", "body_image-cloudy", "body_image-fog", "body_image-hail", "body_image-partly-cloudy-day", "body_image-partly-cloudy-night", "body_image-rain", "body_image-sleet", "body_image-snow", "body_image-thunderstorm", "body_image-tornado", "body_image-wind"]

// UserDefaults
let metric = UserDefaults.standard.bool(forKey: "metric")
let imperial = UserDefaults.standard.bool(forKey: "imperial")

