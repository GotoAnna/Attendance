//
//  SignUpUserViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/24.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpUserViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //TextField外をタップするとキーボードを閉じる
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commitButtonTapped))
                tapGR.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func commitButtonTapped() {
            self.view.endEditing(true)
        }
    
    func setUpElements(){
        errorLabel.alpha = 0 //エラーを隠す
        
        //スタイル
        Utilities.styleTextField(userNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    //フィールドを検証するメソッド
    //フィールドをチェックし, 全て正しい場合は, データが正しいことを検証する
    //return nil, それ以外はエラーメッセージを返す
    func validateFields() -> String?{
        
        //TextFieldが空の場合, エラーメッセージを返す
        if userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill in all fields."
        }
        //パスワードが安全かどうか確認
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false{
            //パスワードが十分でない
            return "Passward is at least 8 chracters, contains a special character($@$#!%*?&) and a number(123456789). ex)tester1234@"
        }
        
        return nil
    }
    
    @IBAction func signUPTapped(_ sender: Any) {
        //フィールドを検証
        let error = validateFields()
        
        if error != nil{
            //エラーメッセージを表示
           showError(error!)
        }
        else{
            let userName = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //ユーザーを作成
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //エラーをチェック
                if err != nil{
                    self.showError("Error creating user")
                }
                else{
                    //成功したら, 名前をストアに保存
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["username": userName, "uid": result!.user.uid]){(error) in
                       
                       let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = userName
                        changeRequest?.commitChanges { (error) in
                            if let error = error {
                                      print("エラー")
                                    } else {
                                      print("成功:\(changeRequest?.displayName)")
                                    }
                        }
                        
                        if error != nil{
                            self.showError("User date couldn't")
                        }
                    }
                    //ホーム画面に移行
                    self.transitionToHome()
                }
                
            }
        }
    }
    
    func showError(_ message:String)
    {
        //エラーメッセージを表示
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome()
    {
        //let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //view.window?.rootViewController = homeViewController
        view.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "topNavigationController")
        view.window?.makeKeyAndVisible()
        
        //self.performSegue(withIdentifier: "toHome", sender: self)
    }
}
