//
//  ViewController.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit

class WAHomeViewController: UIViewController {
    
    
    //MARK: - Outlets


    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    //MARK: - Actions

    @IBAction func buttonPressed(_ sender: Any) {
        WeatherNetworkManager.getWeather(success: { (response) in
            
            print("Get weather response: \(response)")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}

