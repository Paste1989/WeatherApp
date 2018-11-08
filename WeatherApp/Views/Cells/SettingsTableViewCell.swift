//
//  SettingsTableViewCell.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 09.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var isPressed: Bool!
    
    //MARK: - Outlets
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!

    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isPressed = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK: - Actions
    @IBAction func confirmationButtonPressed(_ sender: Any) {
        if isPressed == true {
            isPressed = false
            let uncheckImage = UIImage(named: "square_checkmark_uncheck")
            confirmationButton.setImage(uncheckImage, for: .normal)
        }
        else {
            isPressed = true
            
            let checkImage = UIImage(named: "square_checkmark_check")
            confirmationButton.setImage(checkImage, for: .normal)
        }
    }
}
