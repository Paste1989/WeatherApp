//
//  WANetworkManager.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit
import Foundation
import Foundation
import Alamofire
import SwiftyJSON

var baseURL: String = "https://api.darksky.net/forecast/a37b2331d675e600a19a4f676c1a538b/"
var geoURL: String = "http://api.geonames.org/searchJSON?name_startsWith=#CHANGE#&maxRows=100&username=paste1989"
var geoLocationURLbase: String = "http://api.geonames.org/findNearbyPlaceNameJSON?lat=#CHANGE1#&lng=#CHANGE2#&username=paste1989"


struct WeatherNetworkManager {

    static func getWeather(latitude: String, longitude: String, success: @escaping (JSON) -> Void, failure: @escaping(Error) -> Void) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        WASyncManager.request(url: baseURL+"\(latitude),\(longitude)", method: .get, parameters: nil, header: headers, success: { (response) in
            success(response)
            print("response: \(response)")
        }) { (error) in
            failure(error)
            print(error.localizedDescription)
        }
    }
    
    static func getWeatherByLocationName(latitude: String, longitude: String, success: @escaping (JSON) -> Void, failure: @escaping(Error) -> Void) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        
        WASyncManager.request(url: baseURL+"\(latitude),\(longitude)", method: .get, parameters: nil, header: headers, success: { (response) in
            success(response)
            print("response: \(response)")
        }) { (error) in
            failure(error)
            print(error.localizedDescription)
        }
    }
    
    static func searchLocation(name_startsWith: String, success: @escaping (JSON) -> Void, failure: @escaping(Error) -> Void) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"]
        
        let filterURL = geoURL.replacingOccurrences(of: "#CHANGE#", with: name_startsWith)
        
        WASyncManager.request(url: filterURL, method: .get, parameters: nil, header: headers, success: { (response) in
            success(response)
            print("response: \(response)")
        }) { (error) in
            failure(error)
            print(error.localizedDescription)
        }
    }
    
    
    static func getLocationName(latitude: Double, longitude: Double, success: @escaping (JSON) -> Void, failure: @escaping(Error) -> Void) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        let filterURL = geoLocationURLbase.replacingOccurrences(of: "#CHANGE1#", with: "\(latitude)")
        let finalURL = filterURL.replacingOccurrences(of: "#CHANGE2#", with: "\(longitude)")
        
        WASyncManager.request(url: finalURL, method: .get, parameters: nil, header: headers, success: { (response) in
            success(response)
            print("response: \(response)")
        }) { (error) in
            failure(error)
            print(error.localizedDescription)
        }
    }
}
