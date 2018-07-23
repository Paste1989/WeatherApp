//
//  Location.swift
//  WeatherApp
//
//  Created by Brezonje on 12.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Location: NSObject {
   
    var placeName: String!
    var latitude: String!
    var longitude: String!
    
    init(json: JSON) {
        self.placeName = json["placeName"].stringValue
        self.latitude = json["latitude"].stringValue
        self.longitude = json["longitude"].stringValue
    }
}
