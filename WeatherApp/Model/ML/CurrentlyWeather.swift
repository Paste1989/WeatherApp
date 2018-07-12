//
//  CurrentlyWeather.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class CurrentlyWeather: NSObject {
    
    var humidity: Double!
    var icon: String!
    var pressure: Double!
    var temperature: Double!
    var time: Int!
    var windSpeed: Double!
    var summary: String!
    
    
    init(json: JSON) {
       
        self.humidity = json["humidity"].doubleValue
        self.icon = json["icon"].stringValue
        self.pressure = json["pressure"].doubleValue
        self.temperature = json["temperature"].doubleValue
        self.time = json["time"].intValue
        self.windSpeed = json["windSpeed"].doubleValue
        self.summary = json["summary"].stringValue
    }
}
