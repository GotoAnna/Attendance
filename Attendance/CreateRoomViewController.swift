//
//  CreateRoomViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/27.
//

import UIKit
var roomnameArray = [String]()
var roomnumberArray = [String]()

class CreateRoomViewController: UIViewController {

    //var roomnameArray = [String]()
    //var roomnumberArray1 = [String]()
    
    @IBOutlet weak var roomnameTextField: UITextField!
    
    @IBOutlet weak var roomnumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func createRoom(_ sender: Any) {
        
        roomnameArray.append(roomnameTextField.text!)
        roomnumberArray.append(roomnumberTextField.text!)
        
        UserDefaults.standard.set(roomnameArray, forKey: "RoomName") //変数の中身をUserDefaultsに追加
        UserDefaults.standard.set(roomnumberArray, forKey: "RoomNumber")
        
        print(roomnameArray)
        
        let alert: UIAlertController = UIAlertController(title:"保存", message: "保存が完了しました。", preferredStyle: .alert)
        
        //OKボタン
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: {action in
                    self.navigationController?.popViewController(animated: true) //ボタンが押された時の動作
                    print("OKボタンが押されました！")
                }
                )
        )
        present(alert, animated: true, completion: nil)
        
        // self.navigationController?.popViewController(animated: true)
    }
}
