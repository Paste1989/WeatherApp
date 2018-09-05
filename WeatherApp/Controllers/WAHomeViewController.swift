//
//  WAHomeViewController.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 04.09.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit
import CoreLocation

protocol  WAHomeViewControllerDelegate: class {
    func setImage(image: UIImage)
}

class WAHomeViewController: UIViewController, CLLocationManagerDelegate {
    
    enum WeatherType {
        case clearDay
        case clearNight
        case cloudy
        case fog
        case hail
        case partlyCloudyDay
        case partlyCloudyNight
        case rain
        case sleet
        case snow
        case thunderstorm
        case tornado
        case wind
        
        static func getWeatherType(type: WeatherType) -> String? {
            switch type {
            case .clearDay:
                return "clear-day"
            case .clearNight:
                return "clear-night"
            case .cloudy:
                return "cloudy"
            case .fog:
                return "fog"
            case .hail:
                return "hail"
            case .partlyCloudyDay:
                return "partly-cloudy-day"
            case .partlyCloudyNight:
                return "partly-cloudy-night"
            case .rain:
                return "rain"
            case .sleet:
                return "sleet"
            case .snow:
                return "snow"
            case .thunderstorm:
                return "thunderstorm"
            case .tornado:
                return "tornado"
            case .wind:
                return "wind"
            }
        }
    }

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
    

    let locationManager = CLLocationManager()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        

        DispatchQueue.main.async {
            self.headerImageView.image = self.getHeaderImage
            self.skyColorImageView.image = self.getSkyColorImage
            self.bodyImageView.image = self.getBodyImage
        }
        
        
        
        
        let metric = UserDefaults.standard.bool(forKey: "metric")
        print("METRIC: \(metric)")
        
        let imperial = UserDefaults.standard.bool(forKey: "imperial")
        print("IMPERIAL: \(imperial)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        
//        headerImageView.image = WAHomeViewController.headerImage
//        skyColorImageView.image = WAHomeViewController.skyColorImage
//        bodyImageView.image = WAHomeViewController.bodyImage
        
        temperatureLabel.text = "\(WAHomeViewController.temperatureData)"
        summaryLabel.text = WAHomeViewController.summaryData
        cityLabel.text = WAHomeViewController.cityName
        
        minimalTemperatureLabel.text = "\(WAHomeViewController.minTempData)"
        maximalTemperatureLabel.text = "\(WAHomeViewController.maxTempData)"
        
        humidityLabel.text = "\(WAHomeViewController.humidityData)"
        windLabel.text = "\(WAHomeViewController.windData)"
        pressureLabel.text = "\(WAHomeViewController.pressureData)"
        
        
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

        searchTextField.text = ""
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let lat = UserDefaults.standard.string(forKey: "searchLat")
        let lng = UserDefaults.standard.string(forKey: "searchLng")
        
        if lat != nil && lng != nil {
            
            getWeatherComponents(latitude: lat!, longitude: lng!)
        }
        
         cityLabel.text = WAHomeViewController.cityName
        

        
        let la = (WASearchViewController.la)
        let lo = (WASearchViewController.lo)
        //print("DIDAPPEAR: \(WASearchViewController.destinationName), \(la), \(lo)")
        
        
        getWeatherComponents(latitude: "\(la)", longitude: "\(lo)")  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    //MARK: - Actions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        self.getWeatherComponents(latitude: "\(locValue.latitude)", longitude: "\(locValue.longitude)")
        
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    
    func getWeatherComponents(latitude:String, longitude:String){
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            
            
            WeatherNetworkManager.getWeather(latitude: latitude, longitude: longitude, success: { (response) in
                //print("Get weather response: \(response)")
                
                
                let locationLatitude = (response["latitude"].double)!
                //print("WEATHERLOCATION LATITUDE: \(locationLatitude)")
                
                let locationLongitude = (response["longitude"].double)!
                //print("WEATHERLOCATION LONGITUDE: \(locationLongitude)")
                
                
                WeatherNetworkManager.getLocationName(latitude: locationLatitude, longitude: locationLongitude, success: { (response) in
                    //print("LOCATIONNAMEresponse: \(response)")
                    
                    
                    let geoData = (response["geonames"].array)!
                    //print("GEODATA: \(geoData)")
                    
                    if geoData != [] {
                        
                        let data = (geoData[0].dictionary)!
                        //print("DATAAA: \(data)")
                        
                        let locationName = (data["name"]?.string)!
                        //print("LOCATIONAME: \(locationName)")
                        
                        self.cityLabel.text = locationName
                        WAHomeViewController.cityName = locationName
                        
                        //self.initaialPlace = locationName
                        //print("INITIAL: \(self.initaialPlace)")
 
                    }else {
                        
                    }
                    
                }, failure: { (error) in
                    print(error.localizedDescription)
                })
                
                
                
                if let currentlyData = response["currently"].dictionary {
                    //print("currentlyDATA: \(currentlyData)")
                    
                    let humidityData = (currentlyData["humidity"]?.double)!
                    //print("humidity: \(humidityData)")
                    self.humidityLabel.text = "\(humidityData)"
                    
                    
                    let iconData = (currentlyData["icon"]?.string)!
                    //print("icon: \(iconData)")
                    
                    
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
                    //print("pressure: \(pressureData)")
                    self.pressureLabel.text = "\(pressureData)"
                    
                    self.temperatureLabel.text = WAManager.setTemparature(minTemp: (currentlyData["temperature"]?.double)!)
                    //print("TEMP1: \(self.temperatureLabel.text!)")
                    
                    //time
                    let timeData = (currentlyData["time"]?.int)!
                    //print("time: \(timeData)")
                    self.bodyImageView.image = UIImage(named: "\(timeData)")
                    
                    
                    let windSpeedData = (currentlyData["windSpeed"]?.double)!
                    //print("windSpeed: \(windSpeedData)")
                    self.windLabel.text = "\(windSpeedData)"
                    
                    let summaryData = (currentlyData["summary"]?.string)!
                    //print("summary: \(summaryData)")
                    self.summaryLabel.text = summaryData
                }
                
                
                if let dailyData = response["daily"].dictionary {
                    //print("dailyDATA: \(dailyData)")
                    
                    let data = (dailyData["data"]?.array)!
                    // print("DATA: \(data)")
                    
                    let dataDict = (data[7].dictionary)!
                    //print("temperatureMin: \(dataDict)")
                    
                    
                    self.minimalTemperatureLabel.text = WAManager.setTemparature(minTemp: (dataDict["temperatureMin"]?.double)!)
                    
                    self.maximalTemperatureLabel.text = WAManager.setTemparature(minTemp: (dataDict["temperatureMax"]?.double)!)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }else{
            print("Internet Connection not Available!")
            
            let alert = UIAlertController(title: "Message", message: "Internet Connection not Available!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
//        let storyboard : UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let searchVC : WASearchViewController = (storyboard.instantiateViewController(withIdentifier: "WASearchViewController") as! WASearchViewController)
//
//        self.present(searchVC, animated: false, completion: nil)
        performSegue(withIdentifier: "searchSegue", sender: nil)
    }
    
    
    
    @IBAction func searchTextFieldPressed(_ sender: Any) {
        
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


