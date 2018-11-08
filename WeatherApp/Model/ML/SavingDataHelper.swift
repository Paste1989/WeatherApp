//
//  SavingHelper.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 25.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit

class SavingDataHelper {
    
    class func saveLocation(location: [Location]){
        let locationData = NSKeyedArchiver.archivedData(withRootObject: location)
        UserDefaults.standard.set(locationData, forKey: "locations")
        UserDefaults.standard.synchronize()
    }
    
    class func getLocation() -> [Location]? {
        let locationData = UserDefaults.standard.data(forKey: "locations")
        if locationData != nil {
            if let locations = NSKeyedUnarchiver.unarchiveObject(with: locationData!) as? [Location]{
                return locations
            }
        }
        return [Location]()
    }
    
    static func deleteLocationData() {
        UserDefaults.standard.set(nil, forKey: "locations")
        UserDefaults.standard.synchronize()
    }
    
    
    class func saveData(name: [String]){
        let nameData = NSKeyedArchiver.archivedData(withRootObject: name)
        UserDefaults.standard.set(nameData, forKey: "locationArray")
        UserDefaults.standard.synchronize()
    }
    
    class func getData() -> [String]? {
        let nameData = UserDefaults.standard.data(forKey: "locationArray")
        if nameData != nil {
            if let names = NSKeyedUnarchiver.unarchiveObject(with: nameData!) as? [String]{
                return names
            }
        }
        return [String]()
    }
    
    
    class func saveString(name: String){
        let nameData = NSKeyedArchiver.archivedData(withRootObject: name)
        UserDefaults.standard.set(nameData, forKey: "stringArray")
        UserDefaults.standard.synchronize()
    }
    
    class func getString() -> String? {
        let nameData = UserDefaults.standard.data(forKey: "stringArray")
        if nameData != nil {
            if let names = NSKeyedUnarchiver.unarchiveObject(with: nameData!) as? String{
                return names
            }
        }
        return String()
    }
}
