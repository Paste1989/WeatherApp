//
//  Location.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 12.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Location: NSObject, NSCoding {
   
    var placeName: String!
    var latitude: Double!
    var longitude: Double!
    
    enum Key:String {
        case placeName = "placeName"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    
    init(placeName: String, latitude: Double, longitude: Double) {
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(placeName, forKey: Key.placeName.rawValue)
        aCoder.encode(latitude, forKey: Key.latitude.rawValue)
        aCoder.encode(longitude, forKey: Key.longitude.rawValue)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let latitude = aDecoder.decodeObject(forKey: Key.latitude.rawValue) as! Float64
        let longitude = aDecoder.decodeObject(forKey: Key.longitude.rawValue) as! Float64
        guard let placeName = aDecoder.decodeObject(forKey: Key.placeName.rawValue) as? String else { return nil }
        self.init(placeName: placeName, latitude: latitude, longitude: longitude)
    }
}
