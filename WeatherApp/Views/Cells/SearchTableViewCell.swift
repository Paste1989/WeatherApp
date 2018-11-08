//
//  searchTableViewCell.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 07.07.2018..
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
}
