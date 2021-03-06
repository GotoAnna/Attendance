//
//  LoginViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/24.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        
        errorLabel.alpha = 0
        self.navigationController?.navigationBar.tintColor = UIColor.black
        //スタイル
        Utilities.styleTextField(userNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
    }
  

    @IBAction func loginTapped(_ sender: Any) {
        
        //入力内容の検証
        let userName = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //ユーザーにサンイン
        Auth.auth().signIn(withEmail: email, password: password){
            (result, error) in
            
            if error != nil{
                //サンインできない
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                 changeRequest?.displayName = userName
                 changeRequest?.commitChanges { (error) in
                     if let error = error {
                               print("エラー")
                             } else {
                               print("成功:\(changeRequest?.displayName)")
                             }
                 }
               // let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                //self.view.window?.rootViewController = homeViewController
                self.view.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "topNavigationController")
                self.view.window?.makeKeyAndVisible()
                
                //self.performSegue(withIdentifier: "toHome", sender: self)
            }
        }
    }
}
