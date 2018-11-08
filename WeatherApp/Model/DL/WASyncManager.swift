//
//  WASyncManager.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import Foundation
import Alamofire
import SwiftyJSON



class WASyncManager: NSObject {
    
    class func request(url: String, method: HTTPMethod, parameters: Parameters?, header: HTTPHeaders?, success: @escaping (JSON)->(), failure: @escaping (Error)->()){
        
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
            
            .responseJSON { response in
                switch response.result{
                    
                case .success(let value):
                    let json = JSON(value)
                    if (response.response?.statusCode)! >= 200 && (response.response?.statusCode)! < 400 {
                        success(json)
                    }
                    else {
                        print("Server error")
                        
                        let json: JSON = JSON(response.result.value ?? [])
                        print("Success: \(method.rawValue) REQUEST URL: \(url) - \(response.response?.statusCode ?? -1)'\n'TIMELINE: \(response.timeline)'\n'RESPONSE JSON: \(json)")
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        debugPrint(request)
    }
}
