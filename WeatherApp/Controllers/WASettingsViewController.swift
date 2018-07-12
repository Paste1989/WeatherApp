//
//  WASettingsViewController.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit

class WASettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var getHeaderImage: UIImage!
    var getBodyImage: UIImage!
    var getSkyColorImage: UIImage!
    
    var humidityPressed: Bool!
    var windPressed: Bool!
    var pressurePressed: Bool!
    var metricPressed: Bool!
    var imperialPressed: Bool!
    
    //MARK: - Outlets
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var metricButton: UIButton!
    @IBOutlet weak var imperialButton: UIButton!
    
    @IBOutlet weak var humidityButton: UIButton!
    @IBOutlet weak var windButton: UIButton!
    @IBOutlet weak var pressureButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    @IBOutlet weak var skyColorImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var bodyImageView: UIImageView!
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        pressurePressed = true
        windPressed = true
        humidityPressed = true
        

        
        headerImageView.image = getHeaderImage
        bodyImageView.image = getBodyImage
        skyColorImageView.image = getSkyColorImage

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        if UserDefaults.standard.bool(forKey: "pressure") == false {
            pressurePressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            pressureButton.setImage(uncheckImage, for: .normal)
        }
        else {
             pressurePressed = true
            let checkImage = UIImage(named: "checkmark_check")
            pressureButton.setImage(checkImage, for: .normal)
        }
    
        
        if UserDefaults.standard.bool(forKey: "wind") == false {
            windPressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            windButton.setImage(uncheckImage, for: .normal)
        }
        else {
            windPressed = true
            let checkImage = UIImage(named: "checkmark_check")
            windButton.setImage(checkImage, for: .normal)
        }
        

        if UserDefaults.standard.bool(forKey: "humidity") == false {
            humidityPressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            humidityButton.setImage(uncheckImage, for: .normal)
        }
        else {
            humidityPressed = true
            let checkImage = UIImage(named: "checkmark_check")
            humidityButton.setImage(checkImage, for: .normal)
        }
        
        
        if UserDefaults.standard.bool(forKey: "metric") == false {
            metricPressed = false
            let uncheckImage = UIImage(named: "square_checkmark_uncheck")
            metricButton.setImage(uncheckImage, for: .normal)
             
            UserDefaults.standard.set(true, forKey: "imperial")
            UserDefaults.standard.synchronize()
        }
        else {
            metricPressed = true
            let checkImage = UIImage(named: "square_checkmark_check")
            metricButton.setImage(checkImage, for: .normal)
            
            UserDefaults.standard.set(false, forKey: "imperial")
            UserDefaults.standard.synchronize()
        }
        

        if UserDefaults.standard.bool(forKey: "imperial") == false {
            imperialPressed = false
            let uncheckImage = UIImage(named: "square_checkmark_uncheck")
            imperialButton.setImage(uncheckImage, for: .normal)
            
            UserDefaults.standard.set(false, forKey: "metric")
            UserDefaults.standard.synchronize()
        }
        else {
            imperialPressed = true
            let checkImage = UIImage(named: "square_checkmark_check")
            imperialButton.setImage(checkImage, for: .normal)
            
            UserDefaults.standard.set(true, forKey: "metric")
            UserDefaults.standard.synchronize()
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Actions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBAction func humidityButtonPressed(_ sender: Any) {
        if humidityPressed == true {
            humidityPressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            humidityButton.setImage(uncheckImage, for: .normal)
            print("uncheck")
            
            UserDefaults.standard.set(false, forKey: "humidity")
            UserDefaults.standard.synchronize()
        }
        else {
            humidityPressed = true
            
            let checkImage = UIImage(named: "checkmark_check")
            humidityButton.setImage(checkImage, for: .normal)
            
            UserDefaults.standard.set(true, forKey: "humidity")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func windButtonPressed(_ sender: Any) {
        if windPressed == true {
            windPressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            windButton.setImage(uncheckImage, for: .normal)
            
            UserDefaults.standard.set(false, forKey: "wind")
            UserDefaults.standard.synchronize()
        }
        else {
            windPressed = true
            
            let checkImage = UIImage(named: "checkmark_check")
            windButton.setImage(checkImage, for: .normal)
            
            UserDefaults.standard.set(true, forKey: "wind")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    @IBAction func metricButtonPressed(_ sender: Any) {
        if metricPressed == true {
            metricPressed = false
            imperialPressed = false
            
            let uncheckImage = UIImage(named: "square_checkmark_uncheck")
            imperialButton.setImage(uncheckImage, for: .normal)
            
            UserDefaults.standard.set(false, forKey: "metric")
            UserDefaults.standard.synchronize()
        }
        else {
            metricPressed = true
            imperialPressed = false
            
            let checkImage = UIImage(named: "square_checkmark_check")
            metricButton.setImage(checkImage, for: .normal)
            
            let uncheckImage = UIImage(named: "square_checkmark_uncheck")
            imperialButton.setImage(uncheckImage, for: .normal)
            
            UserDefaults.standard.set(true, forKey: "metric")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func imperialButtonPressed(_ sender: Any) {
        if imperialPressed == true {
            imperialPressed = false
            metricPressed = false
            
            let uncheckImage = UIImage(named: "square_checkmark_uncheck")
            metricButton.setImage(uncheckImage, for: .normal)
            
            UserDefaults.standard.set(false, forKey: "metric")
            UserDefaults.standard.synchronize()
        }
        else {
            imperialPressed = true
            metricPressed = false
            
        
            let checkImage = UIImage(named: "square_checkmark_check")
            imperialButton.setImage(checkImage, for: .normal)
            
            let uncheckImage = UIImage(named: "square_checkmark_uncheck")
            metricButton.setImage(uncheckImage, for: .normal)
            
            UserDefaults.standard.set(true, forKey: "imperial")
            UserDefaults.standard.synchronize()
        }
    }

    
    @IBAction func pressureButtonPressed(_ sender: Any) {
        if pressurePressed == true {
            pressurePressed = false
            let uncheckImage = UIImage(named: "checkmark_uncheck")
            pressureButton.setImage(uncheckImage, for: .normal)
            
            UserDefaults.standard.set(false, forKey: "pressure")
            UserDefaults.standard.synchronize()
        }
        else {
            pressurePressed = true
            
            let checkImage = UIImage(named: "checkmark_check")
            pressureButton.setImage(checkImage, for: .normal)
            
            UserDefaults.standard.set(true, forKey: "pressure")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "WAHomeViewController") as! WAHomeViewController
        
        
        if humidityPressed == false {
            homeVC.humidityImageView?.isHidden = true
            homeVC.humidityLabel?.isHidden = true
        }
        else {
            homeVC.humidityImageView?.isHidden = false
            homeVC.humidityLabel?.isHidden = false
        }
        
        
        UserDefaults.standard.synchronize()
        
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    

    
}
