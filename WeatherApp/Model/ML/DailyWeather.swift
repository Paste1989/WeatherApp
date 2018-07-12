//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DailyWeather : NSObject {
    
    var temperatureMin : Double!
    var temperatureMax: Double!
    
    init(json: JSON) {
        
        self.temperatureMin = json["temperatureMin"].doubleValue
        self.temperatureMax = json["temperatureMax"].doubleValue
    }
}
