//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: UIScreen.main.bounds.size.width-85, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleTextField1(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: UIScreen.main.bounds.size.width-100, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
       // button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.backgroundColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1)
        button.layer.cornerRadius = 20.0
        //button.tintColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderWidth = 3.0    // 枠線の幅
        button.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        //(?=.*[$@$#!%*?&])
        //\\d$@$#!%*?&
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        //let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])[A-Za-z]{4,}")
        return passwordTest.evaluate(with: password)
    }
    
}
