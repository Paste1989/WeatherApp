//
//  WATextField.swift
//  WeatherApp
//
//  Created by Saša Brezovac on 25.07.2018..
//  Copyright © 2018. CopyPaste89. All rights reserved.
//

import Foundation
import UIKit


class WATextField: UITextField {
    var insets: (text: UIEdgeInsets, placeholder: UIEdgeInsets)! = (UIEdgeInsets.zero, UIEdgeInsets.zero)
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, insets.text)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, insets.text)
    }
    
    @IBInspectable var textInsetsLeft: CGFloat {
        get {
            return insets.text.left
        }
        set {
            insets.text.left = newValue
        }
    }
    
    @IBInspectable var textInsetsRight: CGFloat {
        get {
            return insets.text.right
        }
        set {
            insets.text.right = newValue
        }
    }
    
    @IBInspectable var textInsetsTop: CGFloat {
        get {
            return insets.text.top
        }
        set {
            insets.text.top = newValue
        }
    }
    
    @IBInspectable var textInsetsBottom: CGFloat {
        get {
            return insets.text.bottom
        }
        set {
            insets.text.bottom = newValue
        }
    }   
}
