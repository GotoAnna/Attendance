//
//  ViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1)
        
        signUpButton.layer.borderWidth = 3.0    // 枠線の幅
        signUpButton.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        signUpButton.layer.cornerRadius = 20.0
        signUpButton.layer.shadowOpacity = 0.3
        signUpButton.layer.shadowRadius = 5
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func setUpElements(){
        //スタイル
        //Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
    }
    

    
}

