//
//  WASearchViewController.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol  WASearchViewControllerDelegate: class {
    func setImage(image: UIImage)
}

class WASearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    var getHeaderImage: UIImage!
    var getSkyColorImage: UIImage!
    var getBodyImage: UIImage!
    
    weak var delegate : WASearchViewControllerDelegate?
    
    var searchVCLocationsToShow = [Location]()
    static var settingsVCLocationsToShow = [Location]()
    
    var searchItem: String = ""
    var initaialPlace: String = ""

    static var cityName: String!
    static var destinationName: String!
    
    var lat: String = ""
    var lng: String = ""
    
    var latitude: String = ""
    var longitude: String = ""
    
    static var la: Double = 0.0
    static var lo: Double = 0.0
    
    var currentTime: Float = 0.0
    var maxTime: Float = 100
    
    
    var temperatureData: Double!
    var tempCelsius: Int!
    
    var tempMinData: Double!
    var minTempCelsius: Int!
    
    var tempMaxData: Double!
    var maxTempCelsius: Int!
    
    
    //MARK: - Outlets
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var bodyImageView: UIImageView!
    @IBOutlet weak var skyColorImageView: UIImageView!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var closeSearchButton: UIButton!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var minimalTemperatureLabel: UILabel!
    @IBOutlet weak var maximalTemperatureLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var pressureImageView: UIImageView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var searchTextField: WATextField!
    
    @IBOutlet weak var humidityPercentageLabel: UILabel!
    @IBOutlet weak var windMphLabel: UILabel!
    @IBOutlet weak var pressureHpaLabel: UILabel!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchScrollView: UIScrollView!
    @IBOutlet weak var blurEfectView: UIVisualEffectView!
    
    @IBOutlet weak var leadingSearchTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingSearchTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextFieldTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bodyImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var skyColorImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var temperatureLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var humidityHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var humidityWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var humidityLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var humidityPercentageTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var windHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var windWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var windImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var windLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var windMphLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pressureHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pressureWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var humidityTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pressureLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenBoundsSettings()
        searchTextField.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        searchTextField.addTarget(self, action: #selector(self.textChanged(sender:)),for: UIControlEvents.editingChanged)
        
        activityIndicator.isHidden = true
        self.searchTableView.allowsSelection = true

        DispatchQueue.main.async {
            self.bodyImageView.image = self.getBodyImage
            self.headerImageView.image = self.getHeaderImage
            self.skyColorImageView.image = self.getSkyColorImage
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        searchTableView.isHidden = false
        blurEfectView.isHidden = false
        closeSearchButton.isHidden = true
        
        userDefConfiguration()
        
        searchTextField.addImage(direction: .Right, imageName: "search_icon", frame: CGRect(x: -20, y: 0, width: 20, height: 20), backgroundColor: .clear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchTextField.becomeFirstResponder()

        leadingSearchTextFieldConstraint.constant = 20
        trailingSearchTextFieldConstraint.constant = 20
        settingsButton.isHidden = true
        closeSearchButton.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Actions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTextField.text != "" {
            return searchVCLocationsToShow.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        if self.searchTableView == tableView {
            let placeName = (searchVCLocationsToShow[indexPath.row].placeName)!
            cell.cityLabel.text = placeName
            
            var string = placeName
            string = String(string.prefix(1))
            cell.confirmationButton.setTitle(string, for: .normal)
            
            WASearchViewController.cityName = cell.cityLabel.text
            WAHomeViewController.cityName = WASearchViewController.cityName
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        blurEfectView.isHidden = true
        searchTableView.isHidden = true
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        
        WASearchViewController.destinationName = (searchVCLocationsToShow[indexPath.row].placeName)!
        WASearchViewController.la = (searchVCLocationsToShow[indexPath.row].latitude)!
        WASearchViewController.lo = (searchVCLocationsToShow[indexPath.row].longitude)!

        let loc = Location(placeName: WASearchViewController.destinationName, latitude: WASearchViewController.la, longitude: WASearchViewController.lo)
        let locations = (SavingDataHelper.getLocation())!
        
        if !(locations.contains(loc)){
            WASearchViewController.settingsVCLocationsToShow.append(loc)
            SavingDataHelper.saveLocation(location: WASearchViewController.settingsVCLocationsToShow)
        }
        searchVCLocationsToShow.removeAll()
        self.searchTableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

    @objc func textChanged(sender:UITextField) {
        WeatherNetworkManager.searchLocation(name_startsWith: searchTextField.text!, success: { (response) in
            guard let geoData = (response["geonames"].array) else {return}
            if geoData != [] {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
                guard let data = (geoData[0].dictionary) else {return}

                guard let locationName = (data["name"]?.string) else {return}
                if locationName == self.searchTextField.text {
                    let searchLatitude = (data["lat"]?.string)!
                    UserDefaults.standard.set(searchLatitude, forKey: "searchLat")
                    UserDefaults.standard.synchronize()
                    
                    let searchLongitude = (data["lng"]?.string)!
                    UserDefaults.standard.set(searchLongitude, forKey: "searchLng")
                    UserDefaults.standard.synchronize()
                    
                    self.searchItem = locationName
                    if self.searchItem == self.searchTextField.text {
                        let loc = Location(placeName: locationName, latitude: Double(searchLatitude)!, longitude: Double(searchLongitude)!)
                        if !(SavingDataHelper.getLocation()?.contains(loc))!{
                            self.searchVCLocationsToShow.append(loc)
                            SavingDataHelper.saveLocation(location: self.searchVCLocationsToShow)
                        }
                        self.searchTableView.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                }
            }
            self.searchTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        if searchTextField.text == "" {
            searchVCLocationsToShow.removeAll()
        }
        searchTableView.reloadData()
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchTableView.isHidden = false
        blurEfectView.isHidden = false
        leadingSearchTextFieldConstraint.constant = 20
        trailingSearchTextFieldConstraint.constant = 20
        settingsButton.isHidden = true
        closeSearchButton.isHidden = false
        searchTableView.reloadData()
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTableView.isHidden = true
        blurEfectView.isHidden = false
        leadingSearchTextFieldConstraint.constant = 74
        trailingSearchTextFieldConstraint.constant = 73
        settingsButton.isHidden = false
        closeSearchButton.isHidden = true
        searchTextField.text = ""
        searchTableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func getWeatherComponents(latitude:String, longitude:String) {
        if Reachability.isConnectedToNetwork() {
            print("Internet Connection Available!")
            
            WeatherNetworkManager.getWeather(latitude: latitude, longitude: longitude, success: { (response) in
                let locationLatitude = (response["latitude"].double)!
                let locationLongitude = (response["longitude"].double)!
                
                WeatherNetworkManager.getLocationName(latitude: locationLatitude, longitude: locationLongitude, success: { (response) in
                    let geoData = (response["geonames"].array)!
                    if geoData != [] {
                        let data = (geoData[0].dictionary)!
                        
                        let locationName = (data["name"]?.string)!
                        self.cityLabel.text = locationName
                        self.initaialPlace = locationName
                        WAHomeViewController.cityName = self.initaialPlace
                    }
                }, failure: { (error) in
                    print(error.localizedDescription)
                })
                
                if let currentlyData = response["currently"].dictionary {
                    let humidityData = (currentlyData["humidity"]?.double)!
                    self.humidityLabel.text = "\(humidityData)"
                    WAHomeViewController.humidityData = humidityData
                    
                    
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
                        
                        WAHomeViewController.headerImage = self.headerImageView.image
                        WAHomeViewController.bodyImage = self.bodyImageView.image
                        WAHomeViewController.skyColorImage = self.skyColorImageView.image
                    }
                    
                    let pressureData = (currentlyData["pressure"]?.double)!
                    self.pressureLabel.text = "\(pressureData)"
                    WAHomeViewController.pressureData = pressureData
                    
                    self.temperatureLabel.text = WAManager.setTemparature(minTemp: (currentlyData["temperature"]?.double)!)
                    WAHomeViewController.temperatureData = self.temperatureLabel.text!
                    
                    //time
                    let timeData = (currentlyData["time"]?.int)!
                    self.bodyImageView.image = UIImage(named: "\(timeData)")
 
                    let windSpeedData = (currentlyData["windSpeed"]?.double)!
                    self.windLabel.text = "\(windSpeedData)"
                    WAHomeViewController.windData = windSpeedData
 
                    let summaryData = (currentlyData["summary"]?.string)!
                    self.summaryLabel.text = summaryData
                    WAHomeViewController.summaryData = summaryData
                }
                
                if let dailyData = response["daily"].dictionary {
                    let data = (dailyData["data"]?.array)!
                    let dataDict = (data[7].dictionary)!
                    self.minimalTemperatureLabel.text = WAManager.setTemparature(minTemp: (dataDict["temperatureMin"]?.double)!)
                    WAHomeViewController.minTempData = self.minimalTemperatureLabel.text!
                    self.maximalTemperatureLabel.text = WAManager.setTemparature(minTemp: (dataDict["temperatureMax"]?.double)!)
                    WAHomeViewController.maxTempData = self.maximalTemperatureLabel.text!
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
        searchTableView.reloadData()
    }
    
    func userDefConfiguration(){
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
        self.skyColorImageView.layer.configureGradientBackground(UIColor(hex: 0x59B7E0).cgColor, UIColor(hex: 0xD8D8D8).cgColor)
    }
    
    func screenBoundsSettings(){
        if UIScreen.main.bounds.height == 568 {
            headerImageHeightConstraint.constant = 200
            searchTableViewHeightConstraint.constant = 200
            
            bodyImageHeightConstraint.constant = 300
            skyColorImageHeightConstraint.constant = 200
            temperatureLabel.font =  UIFont.init(name: "GothamRounded-Light", size: 72) as Any as! UIFont
            temperatureLabelTopConstraint.constant = -90
            summaryLabel.font = UIFont.init(name: "GothamRounded-Light", size: 24) as Any as! UIFont
            
            cityLabelBottomConstraint.constant = -85
            cityLabel.font = UIFont.init(name: "GothamRounded-Book", size: 36) as Any as! UIFont
            
            viewTopConstraint.constant = 300
            
            minimalTemperatureLabel.font =  UIFont.init(name: "GothamRounded-Light", size: 24) as Any as! UIFont
            maximalTemperatureLabel.font =  UIFont.init(name: "GothamRounded-Light", size: 24) as Any as! UIFont
            lowLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            highLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            
            humidityLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            windLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            pressureLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            
            humidityPercentageLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            windMphLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            pressureHpaLabel.font = UIFont.init(name: "GothamRounded-Light", size: 20) as Any as! UIFont
            
            humidityHeightConstraint.constant = 40
            humidityWidthConstraint.constant = 40
            humidityLabelTrailingConstraint.constant = -30
            humidityPercentageTrailingConstraint.constant = 5
            
            windHeightConstraint.constant = 40
            windWidthConstraint.constant = 55
            windLabelLeadingConstraint.constant = -15
            windMphLeadingConstraint.constant = 5
            
            pressureHeightConstraint.constant = 40
            pressureWidthConstraint.constant = 40
            
            humidityTrailingConstraint.constant = 65
            pressureLeadingConstraint.constant = 65
            
            searchTextFieldTopConstraint.constant = 300
            scrollViewTopConstraint.constant = -150
        }
        else if UIScreen.main.bounds.height == 667 {
            humidityLabelTrailingConstraint.constant = -40
            humidityPercentageTrailingConstraint.constant = 10
            
            windLabelLeadingConstraint.constant = -20
            windMphLeadingConstraint.constant = 10
        }
        else if UIScreen.main.bounds.height == 736 {
            searchTextFieldTopConstraint.constant = 350
            
            humidityLabelTrailingConstraint.constant = -35
            humidityPercentageTrailingConstraint.constant = 5
            
            windImageTopConstraint.constant = 50
            windLabelLeadingConstraint.constant = -20
            windMphLeadingConstraint.constant = 5
        }
        else if UIScreen.main.bounds.height == 812 {
            searchTextFieldTopConstraint.constant = 400
            viewTopConstraint.constant = 450
            windImageTopConstraint.constant = 60
            
            humidityLabelTrailingConstraint.constant = -35
            humidityPercentageTrailingConstraint.constant = 5
            
            windLabelLeadingConstraint.constant = -20
            windMphLeadingConstraint.constant = 5
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeVC = segue.destination as! WAHomeViewController
        homeVC.getHeaderImage = self.headerImageView.image!
        homeVC.getBodyImage = self.bodyImageView.image!
        homeVC.getSkyColorImage = self.skyColorImageView.image
        
        homeVC.delegate = self
    }

    
    @IBAction func closeSearchButtonPressed(_ sender: Any) {
        activityIndicator.isHidden = true
        textFieldDidEndEditing(self.searchTextField)
        searchTextField.resignFirstResponder()
        searchTableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

extension WASearchViewController: WAHomeViewControllerDelegate {
    func setImage(image: UIImage) {
        headerImageView.image = image
        bodyImageView.image = image
        skyColorImageView.image = image
    }
}

