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
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.392, green: 0.972, blue: 0.972, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.392, green: 0.972, blue: 0.972, alpha: 1)
    }
    
    func setUpElements(){
        //スタイル
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
    }
    

    
}

