//
//  Weather.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class Weather: NSObject {
    
    var humidity: Double!
    var icon: String!
    var pressure: Double!
    var temperature: Double!
    var time: Int!
    var windSpeed: Double!
    var summary: String!
    
    var temperatureMin : Double!
    var temperatureMax: Double!
    
    
    
    init(humidity: Double, icon: String, pressure: Double, temperature: Double, time: Int, windSpeed: Double, summary: String, temperatureMin: Double, temperatureMax: Double){
        self.humidity = humidity
        self.icon = icon
        self.pressure = pressure
        self.temperature = temperature
        self.time = time
        self.windSpeed = windSpeed
        self.summary = summary
        
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperatureMax
    }
}
