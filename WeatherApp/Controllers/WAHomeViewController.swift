//
//  ViewController.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit

class WAHomeViewController: UIViewController, UITextFieldDelegate {
    
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
    
    
    

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        searchTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getWeatherComponents()
        
        navigationController?.navigationBar.isHidden = true
        
        searchTextField.addImage(direction: .Right, imageName: "search_icon", frame: CGRect(x: -20, y: 0, width: 20, height: 20), backgroundColor: .clear)
        
        if UserDefaults.standard.bool(forKey: "pressure") == false {
            pressureImageView.isHidden = true
            pressureLabel.isHidden = true
            pressureHpaLabel.isHidden = true
        }
        if UserDefaults.standard.bool(forKey: "humidity") == false {
            humidityImageView.isHidden = true
            humidityLabel.isHidden = true
            humidityPercentageLabel.isHidden = true
        }
        if UserDefaults.standard.bool(forKey: "wind") == false {
            windImageView.isHidden = true
            windLabel.isHidden = true
            windMphLabel.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    //MARK: - Actions
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       performSegue(withIdentifier: "searchScreen", sender: self)
        return false
    }
    
    
    
    func getWeatherComponents(){
        WeatherNetworkManager.getWeather(success: { (response) in
            //print("Get weather response: \(response)")
            
            if let currentlyData = response["currently"].dictionary {
                print("Saša's currentlyDATA: \(currentlyData)")
                
                let humidityData = (currentlyData["humidity"]?.double)!
                //print("saša humidity: \(humidityData)")
                self.humidityLabel.text = "\(humidityData)"
                
                
                let iconData = (currentlyData["icon"]?.string)!
                print("saša icon: \(iconData)")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let searchVC = storyboard.instantiateViewController(withIdentifier: "WASearchViewController") as! WASearchViewController
                
                
                if iconData == "clear-day" {
                    self.headerImageView.image = UIImage(named: "header_image-clear-day")
                    self.bodyImageView.image = UIImage(named: "body_image-clear-day")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                if iconData == "clear-night" {
                    self.headerImageView.image = UIImage(named: "header_image-clear-night")
                    self.bodyImageView.image = UIImage(named: "bodyclearnight")
                    self.skyColorImageView.image = UIImage(named: "")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                if iconData == "cloudy" {
                    self.headerImageView.image = UIImage(named: "header_image-cloudy")
                    self.bodyImageView.image = UIImage(named: "body_image-cloudy")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "fog" {
                    self.headerImageView.image = UIImage(named: "header_image-fog")
                    self.bodyImageView.image = UIImage(named: "body_image-fog")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "hail" {
                    self.headerImageView.image = UIImage(named: "header_image-hail")
                    self.bodyImageView.image = UIImage(named: "body_image-hail")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "partly-cloudy-day" {
                    self.headerImageView.image = UIImage(named: "header_image-partly-cloudy-day")
                    self.bodyImageView.image = UIImage(named: "body_image-partly-cloudy-day")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "partly-cloudy-night" {
                    self.headerImageView.image = UIImage(named: "header_image-partly-cloudy-night")
                    self.bodyImageView.image = UIImage(named: "body_image-partly-cloudy-night")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "rain" {
                    self.headerImageView.image = UIImage(named: "header_image-rain")
                    self.bodyImageView.image = UIImage(named: "body_image-rain")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "sleet" {
                    self.headerImageView.image = UIImage(named: "header_image-sleet")
                    self.bodyImageView.image = UIImage(named: "body_image-sleet")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "snow" {
                    self.headerImageView.image = UIImage(named: "header_image-snow")
                    self.bodyImageView.image = UIImage(named: "body_image-snow")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "thunderstorm" {
                    self.headerImageView.image = UIImage(named: "header_image-thunderstorm")
                    self.bodyImageView.image = UIImage(named: "body_image-thunderstorm")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "tornado" {
                    self.headerImageView.image = UIImage(named: "header_image-tornado")
                    self.bodyImageView.image = UIImage(named: "body_image-tornado")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                else if iconData == "wind" {
                    self.headerImageView.image = UIImage(named: "header_image-wind")
                    self.bodyImageView.image = UIImage(named: "body_image-wind")
                    self.skyColorImageView.image = UIImage(named: "day")
                    
                    searchVC.getHeaderImage = self.headerImageView.image
                    searchVC.getBodyImage = self.bodyImageView.image
                    searchVC.getSkyColorImage = self.skyColorImageView.image
                }
                
                let pressureData = (currentlyData["pressure"]?.double)!
                //print("saša pressure: \(pressureData)")
                self.pressureLabel.text = "\(pressureData)"
                
                self.temperatureData = (currentlyData["temperature"]?.double)!
                //print("saša temperature: \(temperatureData)")
                if UserDefaults.standard.bool(forKey: "imperial") == true{
                    self.temperatureLabel.text = "\(Double(round(1000*self.temperatureData)/1000))"
                }
                
                
                let intTemp = Int(self.temperatureData)
                self.tempCelsius = intTemp.convertToCelsius(fahrenheit: intTemp)
                if UserDefaults.standard.bool(forKey: "metric") == true {
                    self.temperatureLabel.text = "\((self.tempCelsius)!)"
                }
                
                
                
                
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
                
                //MinTemp
                self.tempMinData = (dataDict["temperatureMin"]?.double)!
                //print("Saša tempMinData: \(tempMinData)")
                //self.minimalTemperatureLabel.text = "\(self.tempMinData)"
                if UserDefaults.standard.bool(forKey: "imperial") == true{
                    self.minimalTemperatureLabel.text = "\(Double(round(1000*self.tempMinData)/1000))"
                }
                
                let intMinTemp = Int(self.temperatureData)
                self.minTempCelsius = intMinTemp.convertToCelsius(fahrenheit: intMinTemp)
                if UserDefaults.standard.bool(forKey: "metric") == true {
                    self.minimalTemperatureLabel.text = "\((self.minTempCelsius)!)"
                }
                
                
                //MaxTemp
                self.tempMaxData = (dataDict["temperatureMax"]?.double)!
                //print("Saša tempMaxData: \(tempMaxData)")
                //self.maximalTemperature.text = "\(self.tempMaxData)"
                if UserDefaults.standard.bool(forKey: "imperial") == true{
                    self.maximalTemperatureLabel.text = "\(Double(round(1000*self.tempMaxData)/1000))"
                }
                
                let intMaxTemp = Int(self.temperatureData)
                self.maxTempCelsius = intMaxTemp.convertToCelsius(fahrenheit: intMaxTemp)
                if UserDefaults.standard.bool(forKey: "metric") == true {
                    self.maximalTemperatureLabel.text = "\((self.maxTempCelsius)!)"
                }
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

