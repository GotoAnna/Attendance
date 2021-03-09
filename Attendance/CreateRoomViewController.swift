//
//  CreateRoomViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/27.
//

import UIKit
import Firebase

class CreateRoomViewController: UIViewController {

    //var roomnameArray = [String]()
    //var roomnumberArray1 = [String]()
    
    @IBOutlet weak var roomnameTextField: UITextField!
    
    @IBOutlet weak var roomnumberTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchUserInfoFromFirestore()
        Utilities.styleTextField1(roomnameTextField)
        Utilities.styleTextField1(roomnumberTextField)
        Utilities.styleFilledButton(createButton)
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commitButtonTapped))
                tapGR.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func commitButtonTapped() {
            self.view.endEditing(true)
        }
    
    private func fetchUserInfoFromFirestore(){
        let db = Firestore.firestore()
        
        /*db.collection("room").doc("roomname").update({
            roomname: firebase.firestore.FieldValue.arrayUnion('zaru', 'soba')
        })*/
        db.collection("users").getDocuments{(snapshots, err) in
            if let err = err{
                print("user情報の取得に失敗\(err)")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
                let data = snapshot.data()
                
                print("data: ", data)
            })
        }
    }

    @IBAction func createRoom(_ sender: Any) {
        
        let roomName = roomnameTextField.text!
        let roomNumber = roomnumberTextField.text!
        
        if roomName == "" || roomNumber == ""{
            let alert: UIAlertController = UIAlertController(title:"エラー", message: "入力がされていません。", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: {action in
                        print("OKボタンが押されました！")
                    }
                    )
            )
            present(alert, animated: true, completion: nil)
        }
        else{
            Firestore.firestore().collection("room").document(roomName).setData(["roomName": roomName, "roomNumber": roomNumber, "roomEnterNum": "0"])
            //addDocument(data: ["roomname":roomName, "roomnumber":roomNumber])
            
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
        }
    }
}
