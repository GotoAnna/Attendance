//
//  AddViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/27.
//

import UIKit
import Firebase
import FirebaseAuth

class AddViewController: UIViewController {

    private let cellid = "cellid"
    //let nameTitles = ["後藤 杏奈", "A子", "B子"]
    //let image = ["6人", "8人", "10人"]
    var enterRoom: String!
    var enterArray = [Rooms]()
    var EnterUser: String!
    var enterFlag: Int = 0
    
    @IBOutlet weak var addTableView: UITableView!
    
    @IBOutlet weak var enterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enterArray = [Rooms]()
        // Do any additional setup after loading the view.
        addTableView.delegate = self
        addTableView.dataSource = self
        
        let RoomData = Firestore.firestore().collection("room").document(enterRoom).collection("enterUser")
        
        RoomData.getDocuments{ (snapshots, err) in
            if let err = err{
                print("失敗")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
               // let dic = snapshot.data()
                let room = Rooms(document: snapshot)
                //self.enterArray = [Rooms]()
                self.enterArray.append(room)
                //print(room.enterUser)
            })
            DispatchQueue.main.async {
                self.addTableView.reloadData() //TableViewの更新
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
    }
    
    @IBAction func EnterButton() {
        
        //enterArray = [Rooms]()
        let user = Auth.auth().currentUser
        
        if let user = user {
            
            let uid = user.uid
            let RoomData = Firestore.firestore().collection("room").document(enterRoom).collection("enterUser")
            
            RoomData.document(uid).setData(["enterUserID": uid])
            
            for data in enterArray{
                if data.enterUser == uid{ //部屋に本人のidがあったらidを消去
                    RoomData.document(uid).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                        print("入室")
                        self.enterButton.title = "入室"
                    }
                }
                else{ //部屋に本人のidがなかったらidを追加
                    RoomData.document(uid).setData(["enterUserID": uid])
                    print("退室")
                    enterButton.title = "退出"
                }
            }
        }
        DispatchQueue.main.async {
            self.addTableView.reloadData() //TableViewの更新
        }
    }
}
            //RoomData.document(uid).setData(["enterUserID": uid])
          /*
            RoomData.whereField("enterUserID", isEqualTo: uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        //ユーザーの追加
                        RoomData.document(uid).setData(["enterUser": uid])
                        print("Enter")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                        //ユーザーの消去
                       print("Exit")
                        RoomData.document(uid).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    }
            }*/
       
        //単一ドキュメントの取得
       /* var docRef = db.collection("cities").doc("SF");

        docRef.get().then(function(doc) {
            if (doc.exists) {
                console.log("Document data:", doc.data());
            } else {
                console.log("No such document!");
            }
        }).catch(function(error) {
            console.log("Error getting document:", error);
        });*/
        
        //コレクション内の全ドキュメントを取得
        /*db.collection("cities").get().then(function(querySnapshot) {
            querySnapshot.forEach(function(doc) {
                console.log(doc.id, " => ", doc.data());
            });
        });*/


extension AddViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return enterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! AddCustomTableViewCell
           
           // セルに値を設定
        //cell.nameLabel.text = nameTitles[indexPath.row]
       
        return cell
    }
    
    //セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           // performSegue(withIdentifier: "toAdd", sender: nil)
    }
}
