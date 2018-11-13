//
//  WAHomeViewController.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit
import CoreLocation

protocol  WAHomeViewControllerDelegate: class {
    func setImage(image: UIImage)
}

class WAHomeViewController: UIViewController, CLLocationManagerDelegate {
    
    static var temperatureData: String = ""
    static var summaryData: String = ""
    static var cityName: String = ""
    
    static var minTempData: String = ""
    static var maxTempData: String = ""
    
    static var humidityData: Double = 0.0
    static var windData: Double = 0.0
    static var pressureData: Double = 0.0
    
    static var headerImage: UIImage!
    static var skyColorImage: UIImage!
    static var bodyImage: UIImage!
    
    var getHeaderImage: UIImage!
    var getBodyImage: UIImage!
    var getSkyColorImage: UIImage!
    
    let locationManager = CLLocationManager()
    
    weak var delegate : WAHomeViewControllerDelegate?
    
    
    //MARK: - Outlets
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var skyColorImageView: UIImageView!
    @IBOutlet weak var bodyImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var minimalTemperatureLabel: UILabel!
    @IBOutlet weak var maximalTemperatureLabel: UILabel!
    
    @IBOutlet weak var lowlabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var pressureImageView: UIImageView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityPercentageLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windMphLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var pressureHpaLabel: UILabel!
    
    @IBOutlet weak var searchTextField: WATextField!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var headerImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bodyImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var temperatureLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var windTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var humidityLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pressureTrailingConstraint: NSLayoutConstraint!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenBoundsSettings()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        DispatchQueue.main.async {
            self.headerImageView.image = self.getHeaderImage
            self.skyColorImageView.image = self.getSkyColorImage
            self.bodyImageView.image = self.getBodyImage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userDefConfiguration()
        
        self.navigationController?.navigationBar.isHidden = true
        
        temperatureLabel.text = "\(WAHomeViewController.temperatureData)"
        summaryLabel.text = WAHomeViewController.summaryData
        cityLabel.text = WAHomeViewController.cityName
        minimalTemperatureLabel.text = "\(WAHomeViewController.minTempData)"
        maximalTemperatureLabel.text = "\(WAHomeViewController.maxTempData)"
        humidityLabel.text = "\(WAHomeViewController.humidityData)"
        windLabel.text = "\(WAHomeViewController.windData)"
        pressureLabel.text = "\(WAHomeViewController.pressureData)"
        searchTextField.text = ""
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//                let lat = UserDefaults.standard.string(forKey: "searchLat")
//                let lng = UserDefaults.standard.string(forKey: "searchLng")
//                if lat != nil && lng != nil {
//                    getWeatherComponents(latitude: lat!, longitude: lng!)
//                    cityLabel.text = WAHomeViewController.cityName
//                }
        
        
        let la = (WASearchViewController.la)
        let lo = (WASearchViewController.lo)
        getWeatherComponents(latitude: "\(la)", longitude: "\(lo)")  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Actions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.getWeatherComponents(latitude: "\(locValue.latitude)", longitude: "\(locValue.longitude)")
        
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    
    func getWeatherComponents(latitude:String, longitude:String){
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            
            WeatherNetworkManager.getWeather(latitude: latitude, longitude: longitude, success: { (response) in
                
                if response.error == nil {
                    let locationLatitude = (response["latitude"].double)!
                    let locationLongitude = (response["longitude"].double)!
                    
                    WeatherNetworkManager.getLocationName(latitude: locationLatitude, longitude: locationLongitude, success: { (response) in
                        
                        if response.error == nil {
                            guard let geoData = (response["geonames"].array) else {return}
                            
                            if geoData != [] {
                                let data = (geoData[0].dictionary)!
                                
                                let locationName = (data["name"]?.string)!
                                self.cityLabel.text = locationName
                                WAHomeViewController.cityName = locationName
                            }
                        }
                    }, failure: { (error) in
                        print(error.localizedDescription)
                    })
                    
                    if let currentlyData = response["currently"].dictionary {
                        let humidityData = (currentlyData["humidity"]?.double)!
                        self.humidityLabel.text = "\(humidityData)"
                        let iconData = (currentlyData["icon"]?.string)!
                        
                        DispatchQueue.main.async {
                            let clearDay: String = WeatherType.getWeatherType(type: .clearDay)!
                            
                            if clearDay == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(clearDay)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(clearDay)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                            }
                            
                            let clearNight: String = WeatherType.getWeatherType(type: .clearNight)!
                            if clearNight == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(clearNight)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(clearNight)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x044663).cgColor, UIColor(hex: 0x234880).cgColor)
                            }
                            
                            let cloudy: String = WeatherType.getWeatherType(type: .cloudy)!
                            if cloudy == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(cloudy)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(cloudy)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                            }
                            
                            let fog: String = WeatherType.getWeatherType(type: .fog)!
                            if fog == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(fog)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(fog)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0xABD6E9).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                            }
                            
                            let hail: String = WeatherType.getWeatherType(type: .hail)!
                            if hail == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(hail)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(hail)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                            }
                            
                            let partlyCloudyDay: String = WeatherType.getWeatherType(type: .partlyCloudyDay)!
                            if partlyCloudyDay == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(partlyCloudyDay)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(partlyCloudyDay)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                            }
                            
                            let partlyCloudyNight: String = WeatherType.getWeatherType(type: .partlyCloudyNight)!
                            if partlyCloudyNight == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(partlyCloudyNight)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(partlyCloudyNight)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x044663).cgColor, UIColor(hex: 0x234880).cgColor)
                            }
                            
                            let rain: String = WeatherType.getWeatherType(type: .rain)!
                            if rain == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(rain)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(rain)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x15587B).cgColor, UIColor(hex: 0x4A75A2).cgColor)
                            }
                            
                            let sleet: String = WeatherType.getWeatherType(type: .sleet)!
                            if sleet == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(sleet)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(sleet)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                            }
                            
                            let snow: String = WeatherType.getWeatherType(type: .snow)!
                            if snow == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(snow)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(snow)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x0B3A4E).cgColor, UIColor(hex: 0x80D5F3).cgColor)
                            }
                            
                            let thunderstorm: String = WeatherType.getWeatherType(type: .thunderstorm)!
                            if thunderstorm == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(thunderstorm)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(thunderstorm)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x15587B).cgColor, UIColor(hex: 0x4A75A2).cgColor)
                            }
                            
                            let tornado: String = WeatherType.getWeatherType(type: .tornado)!
                            if tornado == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(tornado)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(tornado)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x15587B).cgColor, UIColor(hex: 0x4A75A2).cgColor)
                            }
                            
                            let wind: String = WeatherType.getWeatherType(type: .wind)!
                            if wind == iconData {
                                self.headerImageView.image = UIImage(named: "header_image-\(wind)")
                                self.bodyImageView.image = UIImage(named: "body_image-\(wind)")
                                self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                            }
                        }
                        
                        let pressureData = (currentlyData["pressure"]?.double)!
                        self.pressureLabel.text = "\(pressureData)"
                        
                        self.temperatureLabel.text = WAManager.setTemparature(minTemp: (currentlyData["temperature"]?.double)!)
                        
                        //time
                        let timeData = (currentlyData["time"]?.int)!
                        self.bodyImageView.image = UIImage(named: "\(timeData)")
                        
                        let windSpeedData = (currentlyData["windSpeed"]?.double)!
                        self.windLabel.text = "\(windSpeedData)"
                        
                        let summaryData = (currentlyData["summary"]?.string)!
                        self.summaryLabel.text = summaryData
                    }
                    
                    if let dailyData = response["daily"].dictionary {
                        let data = (dailyData["data"]?.array)!
                        let dataDict = (data[7].dictionary)!
                        
                        self.minimalTemperatureLabel.text = WAManager.setTemparature(minTemp: (dataDict["temperatureMin"]?.double)!)
                        self.maximalTemperatureLabel.text = WAManager.setTemparature(minTemp: (dataDict["temperatureMax"]?.double)!)
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        else{
            print("Internet Connection not Available!")
            
            let alert = UIAlertController(title: "Message", message: "Internet Connection not Available!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func screenBoundsSettings(){
        if UIScreen.main.bounds.height == 568 {
            temperatureLabelTopConstraint.constant = 30
            summaryLabelTopConstraint.constant = -30
            locationLabelTopConstraint.constant = -40
            viewTopConstraint.constant = 20
            searchTextFieldTopConstraint.constant = 40
            humidityLeadingConstraint.constant = -70
            pressureTrailingConstraint.constant = -70
            
            temperatureLabel.font =  UIFont.init(name: "GothamRounded-Light", size: 70) as Any as! UIFont
            summaryLabel.font = UIFont.init(name: "GothamRounded-Light", size: 24) as Any as! UIFont
            cityLabel.font = UIFont.init(name: "GothamRounded-Book", size: 36) as Any as! UIFont
            minimalTemperatureLabel.font =  UIFont.init(name: "GothamRounded-Light", size: 24) as Any as! UIFont
            maximalTemperatureLabel.font =  UIFont.init(name: "GothamRounded-Light", size: 24) as Any as! UIFont
            lowlabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            highLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            humidityLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            windLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            pressureLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            humidityPercentageLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            windMphLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            pressureHpaLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
        }
        else if UIScreen.main.bounds.height == 667 {
        }
        else if UIScreen.main.bounds.height == 736 {
        }
        else if UIScreen.main.bounds.height == 812 {
            temperatureLabelTopConstraint.constant = 80
            locationLabelTopConstraint.constant = 120
            viewTopConstraint.constant = 50
            searchTextFieldTopConstraint.constant = 80
        }
    }
    
    func userDefConfiguration() {
        if UserDefaults.standard.bool(forKey: "pressure") == false {
            pressureImageView.isHidden = true
            pressureLabel.isHidden = true
            pressureHpaLabel.isHidden = true
        }
        else if UserDefaults.standard.bool(forKey: "pressure") == true {
            pressureImageView.isHidden = false
            pressureLabel.isHidden = false
            pressureHpaLabel.isHidden = false
        }
        if UserDefaults.standard.bool(forKey: "humidity") == false {
            humidityImageView.isHidden = true
            humidityLabel.isHidden = true
            humidityPercentageLabel.isHidden = true
        }
        else if UserDefaults.standard.bool(forKey: "humidity") == true {
            humidityImageView.isHidden = false
            humidityLabel.isHidden = false
            humidityPercentageLabel.isHidden = false
        }
        if UserDefaults.standard.bool(forKey: "wind") == false {
            windImageView.isHidden = true
            windLabel.isHidden = true
            windMphLabel.isHidden = true
        }
        else if UserDefaults.standard.bool(forKey: "wind") == true {
            windImageView.isHidden = false
            windLabel.isHidden = false
            windMphLabel.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegue" {
            let searchVC = segue.destination as! WASearchViewController
            searchVC.getHeaderImage = self.headerImageView.image
            searchVC.getBodyImage = self.bodyImageView.image
            searchVC.getSkyColorImage = self.skyColorImageView.image
            searchVC.delegate = self
        }
        else if segue.identifier == "settingsSegue" {
            let settingsVC = segue.destination as! WASettingsViewController
            settingsVC.getHeaderImage = self.headerImageView.image!
            settingsVC.getBodyImage = self.bodyImageView.image!
            settingsVC.getSkyColorImage = self.skyColorImageView.image
            settingsVC.delegate = self
        }
    }
    
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    
    @IBAction func textfieldButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "searchSegue", sender: nil)
    }
}

extension WAHomeViewController: WASearchViewControllerDelegate {
    func setImage(image: UIImage) {
        headerImageView.image = image
        bodyImageView.image = image
        skyColorImageView.image = image
    }
}

extension WAHomeViewController: WASettingsViewControllerDelegate {
    func addImage(image: UIImage) {
        headerImageView.image = image
        bodyImageView.image = image
        skyColorImageView.image = image
    }
}


