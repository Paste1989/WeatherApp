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
        UserDefaults.standard.set(nameData, forKey: "locationArray")
        UserDefaults.standard.synchronize()
    }
    
    class func getString() -> String? {
        let nameData = UserDefaults.standard.data(forKey: "locationArray")
        if nameData != nil {
            if let names = NSKeyedUnarchiver.unarchiveObject(with: nameData!) as? String{
                return names
            }
        }
        return String()
    }
    
    
}
