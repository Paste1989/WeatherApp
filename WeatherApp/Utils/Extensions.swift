//
//  Extensions.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 09.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit


class RoundButton: UIButton {
    
    @IBInspectable var roundButton: Bool = false {
        didSet{
            if roundButton {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
}



extension UITextField {
    enum Direction
    {
        case Left
        case Right
    }
    
    func addImage(direction:Direction, imageName: String, frame: CGRect, backgroundColor: UIColor)
    {
        let View = UIView(frame: frame)
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: imageName)
        
        View.addSubview(imageView)
        
        if Direction.Left == direction
        {
            self.leftViewMode = .always
            self.leftView = View
        }
        else
        {
            self.rightViewMode = .always
            self.rightView = View
        }
    }
}


extension Int {
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
    func convertToFahrenheit(temperature: Double) -> Double {
        let fahrenheitTemperature = temperature * 9 / 5 + 32
        return fahrenheitTemperature
    }
}

//ScrollView
extension UIScrollView {
    
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}
