//
//  WAManager.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit


//Singleton

class WAManager: NSObject {
    
    static let shared: WAManager = WAManager()
    
    private override init() {
    }

    class func setTemparature(minTemp : Double) -> String{
        if UserDefaults.standard.bool(forKey: "imperial") == true{
            return "\(Double(round(1000*minTemp)/1000)) °F"
        } else if UserDefaults.standard.bool(forKey: "metric") == true{
             let minTempCelsius = WAManager.convertToCelsius(fahrenheit: minTemp)
            return "\(minTempCelsius) °C"
        }
        return "\(minTemp)"
    }
    
    class func convertToCelsius(fahrenheit: Double) -> Int{
            return Int(5.0 / 9.0 * (fahrenheit - 32.0))
    }
    
}
