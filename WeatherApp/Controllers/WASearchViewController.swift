//
//  WASearchViewController.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 06.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class WASearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    static var searchTerm: String!
    
    var placeArray = [String]()
    
    var getHeaderImage: UIImage!
    var getBodyImage: UIImage!
    var getSkyColorImage: UIImage!
    
    
    var searchItem: String!
    

    //MARK: - Outlets
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchScrollView: UIScrollView!
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var skyColorImageView: UIImageView!
    
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarBottomConstraint: NSLayoutConstraint!
    
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //        headerImageView.image = getHeaderImage
        //        bodyImageView.image = getBodyImage
        //        skyColorImageView.image = getSkyColorImage
        
        
        searchTextField.addTarget(self, action: #selector(self.textChanged(sender:)),for: UIControlEvents.editingChanged)
        
        self.searchTableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor.clear
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        let backButton = UIImage(named: "checkmark_uncheck")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: backButton, style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        
        searchTextField.addImage(direction: .Right, imageName: "search_icon", frame: CGRect(x: -20, y: 0, width: 20, height: 20), backgroundColor: .clear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerKeyboardNotifications()
        searchTextField.becomeFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Action
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
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) 
    {
      
    }
    

    
    @objc func textChanged(sender:UITextField) {
        WeatherNetworkManager.getLocation(username: "paste1989", name_startsWith: searchTextField.text!, success: { (response) in
            print("RESPONSE: \(response)")
            
            let geonameData = (response["geonames"].array)!
            print("GEONAMEDATA: \(geonameData)")
            
            let nameDataDict = (geonameData[0].dictionary)!
            print("NAMEDATA: \(nameDataDict)")
            
            let nameDataString = (nameDataDict["name"]?.string)!
            print("NNNAME: \(nameDataString)")
            
            self.searchItem = nameDataString
            
            self.placeArray.append(self.searchItem)
            print("PLACEARRAY: \(self.placeArray)")
            
            
            WASearchViewController.searchTerm = self.searchTextField.text!
            print("SEARCHTERM: \((WASearchViewController.searchTerm))")
            
            self.searchTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    

    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        searchScrollView.contentInset = contentInsets
        searchScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        searchScrollView.contentInset = .zero
        searchScrollView.scrollIndicatorInsets = .zero
    }
    
    @IBAction func goBackButtonPressed(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
    
    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
}
