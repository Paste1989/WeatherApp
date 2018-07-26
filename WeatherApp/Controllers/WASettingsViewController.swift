//
//  WASettingsViewController.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit

protocol WASettingsViewControllerDelegate: class {
    func addImage(image: UIImage)
}

class WASettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var weather = [Weather]()
    
    var getHeaderImage: UIImage!
    var getBodyImage: UIImage!
    var getSkyColorImage: UIImage!
    
    
    var humidityData: Double = 0.0
    var iconData: String = ""
    var pressureData: Double = 0.0
    var tempData: String = ""
    var timeData: Int = 0
    var windSpeedData: Double = 0.0
    var summaryData: String = ""
    
    var minTempData: String = ""
    var maxTempData: String = ""
    

    weak var delegate : WASettingsViewControllerDelegate?
    
    static var humidityPressed: Bool!
    static var windPressed: Bool!
    static var pressurePressed: Bool!
    static var metricPressed: Bool!
    static var imperialPressed: Bool!
    
    var chosenLocations: [String] = []
    
    
    //MARK: - Outlets
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var metricButton: UIButton!
    @IBOutlet weak var imperialButton: UIButton!
    
    @IBOutlet weak var humidityButton: UIButton!
    @IBOutlet weak var windButton: UIButton!
    @IBOutlet weak var pressureButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    @IBOutlet weak var skyImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var bodyImageView: UIImageView!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locations = (SavingDataHelper.getData())!
        print("LOC: \(locations)")

        
        chosenLocations = locations
        
        
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        
        DispatchQueue.main.async {
            self.headerImageView.image = self.getHeaderImage
            self.bodyImageView.image = self.getBodyImage
            self.skyImageView.image = self.getSkyColorImage
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        
        if UserDefaults.standard.bool(forKey: "pressure") == true {
            WASettingsViewController.pressurePressed = true
            let uncheckImage = UIImage(named: "checkmark_check")
            pressureButton.setImage(uncheckImage, for: .normal)
        }
        else {
            WASettingsViewController.pressurePressed = false
            let checkImage = UIImage(named: "checkmark_uncheck")
            pressureButton.setImage(checkImage, for: .normal)
        }

        if UserDefaults.standard.bool(forKey: "wind") == false {
            WASettingsViewController.windPressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            windButton.setImage(uncheckImage, for: .normal)
        }
        else {
            WASettingsViewController.windPressed = true
            let checkImage = UIImage(named: "checkmark_check")
            windButton.setImage(checkImage, for: .normal)
        }
        

        if UserDefaults.standard.bool(forKey: "humidity") == false {
            WASettingsViewController.humidityPressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            humidityButton.setImage(uncheckImage, for: .normal)
        }
        else {
            WASettingsViewController.humidityPressed = true
            let checkImage = UIImage(named: "checkmark_check")
            humidityButton.setImage(checkImage, for: .normal)
        }
        
        
        
        if WASettingsViewController.metricPressed == true {
            WASettingsViewController.metricPressed = true
            
            WASettingsViewController.imperialPressed = true
            let checkImage = UIImage(named: "square_checkmark_check")
            metricButton.setImage(checkImage, for: .normal)
            UserDefaults.standard.set(true, forKey: "metric")
            UserDefaults.standard.set(false, forKey: "imperial")
            UserDefaults.standard.synchronize()
        }
        else if WASettingsViewController.imperialPressed == true {
            
            WASettingsViewController.imperialPressed = true
            let checkImage = UIImage(named: "square_checkmark_check")
            imperialButton.setImage(checkImage, for: .normal)
            UserDefaults.standard.set(true, forKey: "imperial")
            UserDefaults.standard.set(false, forKey: "metric")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Actions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chosenLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        
        cell.locationLabel.text = chosenLocations[indexPath.row]
        let checkImage = UIImage(named: "square_checkmark_check")
        cell.confirmationButton.setImage(checkImage, for: .normal)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        let checkImage = UIImage(named: "square_checkmark_check")
//        cell.confirmationButton.setImage(checkImage, for: .normal)
        
//        let name = UserDefaults.standard.string(forKey: "searchName")
//        let latitude = UserDefaults.standard.string(forKey: "searchLatitude")
//        let longitude = UserDefaults.standard.string(forKey: "searchLongitude")
        
        
//        WeatherNetworkManager.getWeatherByLocationName(latitude: latitude!, longitude: longitude!, success: { (response) in
//            print(response)
//
//            if let currentlyData = response["currently"].dictionary {
//                print("Saša's currentlyDATA: \(currentlyData)")
//
//                self.humidityData = (currentlyData["humidity"]?.double)!
//
//                self.iconData = (currentlyData["icon"]?.string)!
//
//                self.pressureData = (currentlyData["pressure"]?.double)!
//
//                self.tempData = WAManager.setTemparature(minTemp: (currentlyData["temperature"]?.double)!)
//
//                //time
//                self.timeData = (currentlyData["time"]?.int)!
//
//                self.windSpeedData = (currentlyData["windSpeed"]?.double)!
//
//                self.summaryData = (currentlyData["summary"]?.string)!
//            }
//
//
//            if let dailyData = response["daily"].dictionary {
//                let data = (dailyData["data"]?.array)!
//                let dataDict = (data[7].dictionary)!
//
//                self.minTempData = WAManager.setTemparature(minTemp: (dataDict["temperatureMin"]?.double)!)
//
//                self.maxTempData = WAManager.setTemparature(minTemp: (dataDict["temperatureMax"]?.double)!)
//
//
////                self.weather.append(Weather(humidity: self.humidityData, icon: self.iconData, pressure: self.pressureData, temperature: Double(self.tempData)!, time: self.timeData, windSpeed: self.windSpeedData, summary: self.summaryData, temperatureMin: Double(self.minTempData)!, temperatureMax: Double(self.maxTempData)!))
////
////                WAHomeViewController.finalLocation.append(Location(placeName: name!, latitude: latitude!, longitude: longitude!))
//
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    @IBAction func humidityButtonPressed(_ sender: Any) {
        if WASettingsViewController.humidityPressed == true {
            WASettingsViewController.humidityPressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            humidityButton.setImage(uncheckImage, for: .normal)
            print("uncheck")
            
            UserDefaults.standard.set(false, forKey: "humidity")
            UserDefaults.standard.synchronize()
        }
        else {
            WASettingsViewController.humidityPressed = true
            
            let checkImage = UIImage(named: "checkmark_check")
            humidityButton.setImage(checkImage, for: .normal)
            
            UserDefaults.standard.set(true, forKey: "humidity")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func windButtonPressed(_ sender: Any) {
        if WASettingsViewController.windPressed == true {
            WASettingsViewController.windPressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            windButton.setImage(uncheckImage, for: .normal)
            
            UserDefaults.standard.set(false, forKey: "wind")
            UserDefaults.standard.synchronize()
        }
        else {
            WASettingsViewController.windPressed = true
            
            let checkImage = UIImage(named: "checkmark_check")
            windButton.setImage(checkImage, for: .normal)
            
            UserDefaults.standard.set(true, forKey: "wind")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func metricButtonPressed(_ sender: Any) {
        print("metricPressed")
        WASettingsViewController.metricPressed = true
        WASettingsViewController.imperialPressed = false
            let uncheckImage = UIImage(named: "square_checkmark_uncheck")
            imperialButton.setImage(uncheckImage, for: .normal)

            let checkImage = UIImage(named: "square_checkmark_check")
            metricButton.setImage(checkImage, for: .normal)

            UserDefaults.standard.set(true, forKey: "metric")
            UserDefaults.standard.set(false, forKey: "imperial")
            UserDefaults.standard.synchronize()
    }
    
    
    
    @IBAction func imperialButtonPressed(_ sender: Any) {
        print("imperialPressed")
        WASettingsViewController.imperialPressed = true
        WASettingsViewController.metricPressed = false
        let uncheckImage = UIImage(named: "square_checkmark_uncheck")
        metricButton.setImage(uncheckImage, for: .normal)

        let checkImage = UIImage(named: "square_checkmark_check")
        imperialButton.setImage(checkImage, for: .normal)

        UserDefaults.standard.set(true, forKey: "imperial")
        UserDefaults.standard.set(false, forKey: "metric")
        UserDefaults.standard.synchronize()
    }
    

    @IBAction func pressureButtonPressed(_ sender: Any) {
        if WASettingsViewController.pressurePressed == true {
            WASettingsViewController.pressurePressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            pressureButton.setImage(uncheckImage, for: .normal)
            
            UserDefaults.standard.set(false, forKey: "pressure")
            UserDefaults.standard.synchronize()
        }
        else {
            WASettingsViewController.pressurePressed = true
            
            let checkImage = UIImage(named: "checkmark_check")
            pressureButton.setImage(checkImage, for: .normal)
            
            UserDefaults.standard.set(true, forKey: "pressure")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        UserDefaults.standard.synchronize()
       
        self.dismiss(animated: true, completion: nil)
    }
    

    
}
