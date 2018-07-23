//
//  ViewController.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit
import CoreLocation
import IQKeyboardManagerSwift

class WAHomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
   
    
    var placeArray = [String]()
    var searchItem: String = ""
    
    var cityName: String!
    
    var lat: String = ""
    var lng: String = ""
    
    var latitude: String = ""
    var longitude: String = ""
    
    
    var temperatureData: Double!
    var tempCelsius: Int!
    
    var tempMinData: Double!
    var minTempCelsius: Int!
    
    var tempMaxData: Double!
    var maxTempCelsius: Int!
    
    var headerImageArray: [String] = ["header_image-clear-day", "header_image-clear-night", "header_image-cloudy", "header_image-fog", "header_image-hail", "header_image-partly-cloudy-day", "header_image-partly-cloudy-night", "header_image-rain", "header_image-sleet", "header_image-snow", "header_image-thunderstorm", "header_image-tornado", "header_image-wind"]
   
    
    var bodyImageArray: [String] = ["body_image-clear-day", "body_image-clear-night", "body_image-cloudy", "body_image-fog", "body_image-hail", "body_image-partly-cloudy-day", "body_image-partly-cloudy-night", "body_image-rain", "body_image-sleet", "body_image-snow", "body_image-thunderstorm", "body_image-tornado", "body_image-wind"]
    
    
    //MARK: - Outlets
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var bodyImageView: UIImageView!
    @IBOutlet weak var skyColorImageView: UIImageView!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var minimalTemperatureLabel: UILabel!
    @IBOutlet weak var maximalTemperatureLabel: UILabel!
    
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var pressureImageView: UIImageView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var humidityPercentageLabel: UILabel!
    @IBOutlet weak var windMphLabel: UILabel!
    @IBOutlet weak var pressureHpaLabel: UILabel!
    
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchScrollView: UIScrollView!
    @IBOutlet weak var blurEfectView: UIVisualEffectView!
    
    
    @IBOutlet weak var leadingSearchTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingSearchTextFieldConstraint: NSLayoutConstraint!
    
    
    
    let locationManager = CLLocationManager()
    

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeatherComponents()
      
        searchTextField.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        searchTextField.addTarget(self, action: #selector(self.textChanged(sender:)),for: UIControlEvents.editingChanged)
        
        self.searchTableView.allowsSelection = true
 
        self.searchTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        searchTableView.isHidden = true
        blurEfectView.isHidden = true
        

        searchTextField.addImage(direction: .Right, imageName: "search_icon", frame: CGRect(x: -20, y: 0, width: 20, height: 20), backgroundColor: .clear)
        
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
        
        self.searchTableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placeArray.removeAll()
        
        self.searchTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Actions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTextField.text != "" {
            return placeArray.count
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
            cell.cityLabel.text = placeArray[indexPath.row]
            cityName = cell.cityLabel.text

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        print("cell Pressed")
        
        let checkImage = UIImage(named: "square_checkmark_check")
        cell.imageView?.image = checkImage
        
        cityLabel.text = cityName
        UserDefaults.standard.set(cityName, forKey: "Location")
        
        blurEfectView.isHidden = true
        searchTableView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        dismissKeyboard(tapGesture)
    
        searchTextField.text = ""
        
        
        let latitude = UserDefaults.standard.string(forKey: "searchLatitude")
        let longitude = UserDefaults.standard.string(forKey: "searchLongitude")

        WeatherNetworkManager.getWeather(latitude: latitude!, longitude: longitude!, success: { (response) in
            print("DIDSELECTROWresponse: \(response)")
            
            
            let latitude = (response["latitude"].double)!
            let longitude = (response["longitude"].double)!
            print("LALO: \(latitude), \(longitude)")
            

            
            if let currentlyData = response["currently"].dictionary {
                print("Saša's currentlyDATA: \(currentlyData)")
                
                let humidityData = (currentlyData["humidity"]?.double)!
                //print("saša humidity: \(humidityData)")
                self.humidityLabel.text = "\(humidityData)"
                
                
                let iconData = (currentlyData["icon"]?.string)!
                print("saša icon: \(iconData)")
                
                DispatchQueue.main.async {
                    self.headerImageView.image = UIImage(named: "header_image-\(iconData)")
                    self.bodyImageView.image = UIImage(named: "body_image-\(iconData)")
                    
                    
                    if iconData == "clear-day" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                    }
                    if iconData == "clear-night" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x044663).cgColor, UIColor(hex: 0x234880).cgColor)
                    }
                    if iconData == "cloudy" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                    }
                    else if iconData == "fog" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0xABD6E9).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                    }
                    else if iconData == "hail" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                    }
                    else if iconData == "partly-cloudy-day" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                    }
                    else if iconData == "partly-cloudy-night" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x044663).cgColor, UIColor(hex: 0x234880).cgColor)
                    }
                    else if iconData == "rain" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x15587B).cgColor, UIColor(hex: 0x4A75A2).cgColor)
                    }
                    else if iconData == "sleet" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                    }
                    else if iconData == "snow" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x0B3A4E).cgColor, UIColor(hex: 0x80D5F3).cgColor)
                    }
                    else if iconData == "thunderstorm" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x15587B).cgColor, UIColor(hex: 0x4A75A2).cgColor)
                    }
                    else if iconData == "tornado" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x15587B).cgColor, UIColor(hex: 0x4A75A2).cgColor)
                    }
                    else if iconData == "wind" {
                        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                    }
                }
                
                let pressureData = (currentlyData["pressure"]?.double)!
                //print("saša pressure: \(pressureData)")
                self.pressureLabel.text = "\(pressureData)"
                
                self.temperatureLabel.text = WAManager.setTemparature(minTemp: (currentlyData["temperature"]?.double)!)
                
                //time
                let timeData = (currentlyData["time"]?.int)!
                //print("saša time: \(timeData)")
                self.bodyImageView.image = UIImage(named: "\(timeData)")
                
                
                let windSpeedData = (currentlyData["windSpeed"]?.double)!
                //print("saša windSpeed: \(windSpeedData)")
                self.windLabel.text = "\(windSpeedData)"
                
                let summaryData = (currentlyData["summary"]?.string)!
                print("saša summary: \(summaryData)")
                self.summaryLabel.text = summaryData
            }
            
            
            if let dailyData = response["daily"].dictionary {
                //print("Saša's dailyDATA: \(dailyData)")
                
                let data = (dailyData["data"]?.array)!
                // print("Saša DATA: \(data)")
                
                let dataDict = (data[7].dictionary)!
                //print("Saša temperatureMin: \(dataDict)")
                
                
                self.minimalTemperatureLabel.text = WAManager.setTemparature(minTemp: (dataDict["temperatureMin"]?.double)!)
                
                self.maximalTemperatureLabel.text = WAManager.setTemparature(minTemp: (dataDict["temperatureMax"]?.double)!)
                
//dissmis Keyboard
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
                self.view.addGestureRecognizer(tapGesture)
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    

    @objc func textChanged(sender:UITextField) {
        self.searchTableView.reloadData()
        WeatherNetworkManager.searchLocation(name_startsWith: searchTextField.text!, success: { (response) in
            print("RESPONSE: \(response)")
            
            let geonameData = (response["geonames"].array)!
            print("GEONAMEDATA: \(geonameData)")
            
            let nameDataDict = (geonameData[0].dictionary)!
            print("NAMEDATA: \(nameDataDict)")
            
            let nameDataString = (nameDataDict["name"]?.string)!
            print("NNNAME: \(nameDataString)")
            
            self.searchItem = nameDataString
            print("searchITEM: \(self.searchItem)")
            
            if self.searchItem == self.searchTextField.text {
                self.placeArray.append(self.searchItem)
                print("PLACEARRAY: \(self.placeArray)")
            }
            
            
            

            self.latitude = (nameDataDict["lat"]?.string)!
            print("LATITUDEtextchanged: \(self.latitude)")
            UserDefaults.standard.set(self.latitude, forKey: "searchLatitude")

            self.longitude = (nameDataDict["lng"]?.string)!
            print("LONGITUDEtextchanged: \(self.longitude)")
            UserDefaults.standard.set(self.longitude, forKey: "searchLongitude")
            
            self.searchTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        self.searchTableView.reloadData()
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchTableView.isHidden = false
        blurEfectView.isHidden = false
        
        leadingSearchTextFieldConstraint.constant = 20
        trailingSearchTextFieldConstraint.constant = 20
        settingsButton.isHidden = true
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTableView.isHidden = true
        blurEfectView.isHidden = true
        
        leadingSearchTextFieldConstraint.constant = 74
        trailingSearchTextFieldConstraint.constant = 73
        settingsButton.isHidden = false
        
        searchTextField.text = ""
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsView = segue.destination as! WASettingsViewController
        
        settingsView.getHeaderImage = self.headerImageView.image!
        settingsView.getBodyImage = self.bodyImageView.image!
        settingsView.getSkyColorImage = self.skyColorImageView.image
        
        settingsView.delegate = self
    }
    
    
///////////////////
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")

        
        lat = String(locValue.latitude)
        print("LATT: \(lat)")
        UserDefaults.standard.set(lat, forKey: "currentLat")
        
        lng = String(locValue.longitude)
        UserDefaults.standard.set(lng, forKey: "currentLng")
        
        locationManager.stopUpdatingLocation()
        
    }

    
    func getWeatherComponents(){
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            
            let currentLatitude = (UserDefaults.standard.string(forKey: "currentLat"))!
            let currnetLongitude = (UserDefaults.standard.string(forKey: "currentLng"))!
            
            WeatherNetworkManager.getWeather(latitude: currentLatitude, longitude: currnetLongitude, success: { (response) in
                print("Get weather response: \(response)")
                
                
                let locationLatitude = (response["latitude"].double)!
                print("WEATHERLOCATION LATITUDE: \(locationLatitude)")
                
                let locationLongitude = (response["longitude"].double)!
                print("WEATHERLOCATION LONGITUDE: \(locationLongitude)")
                
                
                WeatherNetworkManager.getLocationName(latitude: locationLatitude, longitude: locationLongitude, success: { (response) in
                    print("LOCATIONNAMEresponse: \(response)")

                    let geoData = (response["geonames"].array)!
                    print("GEODATA: \(geoData)")

                    let data = (geoData[0].dictionary)!
                    print("DATAAA: \(data)")

                    let locationName = (data["name"]?.string)!
                    print("LOCATIONAME: \(locationName)")

                    self.cityLabel.text = locationName
                }, failure: { (error) in
                    print(error.localizedDescription)
                })
                

            
                if let currentlyData = response["currently"].dictionary {
                    print("Saša's currentlyDATA: \(currentlyData)")
                    
                    let humidityData = (currentlyData["humidity"]?.double)!
                    //print("saša humidity: \(humidityData)")
                    self.humidityLabel.text = "\(humidityData)"
                    
                    
                    let iconData = (currentlyData["icon"]?.string)!
                    print("saša icon: \(iconData)")
                    
                    
                    DispatchQueue.main.async {
                        self.headerImageView.image = UIImage(named: "header_image-\(iconData)")
                        self.bodyImageView.image = UIImage(named: "body_image-\(iconData)")
                        
                        
                        if iconData == "clear-day" {
                            self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                        }
                        if iconData == "clear-night" {
                           self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x044663).cgColor, UIColor(hex: 0x234880).cgColor)
                        }
                        if iconData == "cloudy" {
                           self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                        }
                        else if iconData == "fog" {
                             self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0xABD6E9).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                        }
                        else if iconData == "hail" {
                            self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                        }
                        else if iconData == "partly-cloudy-day" {
                             self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                        }
                        else if iconData == "partly-cloudy-night" {
                             self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x044663).cgColor, UIColor(hex: 0x234880).cgColor)
                        }
                        else if iconData == "rain" {
                             self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x15587B).cgColor, UIColor(hex: 0x4A75A2).cgColor)
                        }
                        else if iconData == "sleet" {
                             self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                        }
                        else if iconData == "snow" {
                             self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x0B3A4E).cgColor, UIColor(hex: 0x80D5F3).cgColor)
                        }
                        else if iconData == "thunderstorm" {
                             self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x15587B).cgColor, UIColor(hex: 0x4A75A2).cgColor)
                        }
                        else if iconData == "tornado" {
                             self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x15587B).cgColor, UIColor(hex: 0x4A75A2).cgColor)
                        }
                        else if iconData == "wind" {
                             self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
                        }
                    }
                    
                    let pressureData = (currentlyData["pressure"]?.double)!
                    //print("saša pressure: \(pressureData)")
                    self.pressureLabel.text = "\(pressureData)"
                    
                    self.temperatureLabel.text = WAManager.setTemparature(minTemp: (currentlyData["temperature"]?.double)!)
                  
                    //time
                    let timeData = (currentlyData["time"]?.int)!
                    //print("saša time: \(timeData)")
                    self.bodyImageView.image = UIImage(named: "\(timeData)")
  
                    
                    let windSpeedData = (currentlyData["windSpeed"]?.double)!
                    //print("saša windSpeed: \(windSpeedData)")
                    self.windLabel.text = "\(windSpeedData)"
                    
                    let summaryData = (currentlyData["summary"]?.string)!
                    print("saša summary: \(summaryData)")
                    self.summaryLabel.text = summaryData
                }
                
                
                if let dailyData = response["daily"].dictionary {
                    //print("Saša's dailyDATA: \(dailyData)")
                    
                    let data = (dailyData["data"]?.array)!
                    // print("Saša DATA: \(data)")
                    
                    let dataDict = (data[7].dictionary)!
                    //print("Saša temperatureMin: \(dataDict)")
                    
                    
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
    
//////////////////
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
        
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    
    @IBAction func searchTextFieldPressed(_ sender: Any) {
        placeArray = []
       
    }
}



extension WAHomeViewController: WASettingsViewControllerDelegate {
    func addImage(image: UIImage) {
        headerImageView.image = image
        bodyImageView.image = image
        skyColorImageView.image = image
    }
}

