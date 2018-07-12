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
   
    var name: String!
    
    init(json: JSON) {
        self.name = json["name"].stringValue
    }
    
}
