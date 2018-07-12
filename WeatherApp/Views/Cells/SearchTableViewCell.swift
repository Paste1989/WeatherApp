//
//  searchTableViewCell.swift
//  WeatherApp
//
//  Created by Brezonje on 07.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    var isPressed: Bool!
    
    //MARK: - Outlets
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    

    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
