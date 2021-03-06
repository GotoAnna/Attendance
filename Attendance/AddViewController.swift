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
   
    var enterRoom: String!
    var enterArray = [Rooms]()
    var enterUserName = [Rooms]()
    var enterNameCopy = [Rooms]()
    var enterNumArray = [Rooms]()
    var EnterUser: String!
    var enterFlag: Int = 0
    var iconArray = [Int]()
    var num: Int = 0
    
    @IBOutlet weak var addTableView: UITableView!
    
    @IBOutlet weak var enterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTableView.delegate = self
        addTableView.dataSource = self
    
        
        //navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage.maskCorner(), for: .normal, barMetrics: .default)
        /*let imageButtonItem = UIBarButtonItem(
            image: UIImage(named: "enter.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal),
            style: UIBarButtonItem.Style.plain, target:self, action: "onClickNavBarImageButton")*/
        //self.navigationItem.rightBarButtonItems = [imageButtonItem]
        //self.navigationItem.setRightBarButtonItems([trashButtonItem], animated: true)
        
        
        //let enterName = Firestore.firestore().collection("users")
        let RoomData = Firestore.firestore().collection("room").document(enterRoom).collection("enterUser")
        let RoomNum = Firestore.firestore().collection("room").document(enterRoom)
        
        self.enterArray = [Rooms]()
        
        //enterArrayに(部屋に入室しているユーザーの情報)を格納
        RoomData.getDocuments{ (snapshots, err) in
            if let err = err{
                print("失敗")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
                let room = Rooms(document: snapshot)
                self.enterArray.append(room) //ユーザを追加
            })
            DispatchQueue.main.async {
                self.addTableView.reloadData() //TableViewの更新
            }
            //部屋の詳細画面に遷移した時にを入室・退室ボタンを表示する
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                for data in self.enterArray{ //入室している部屋の中にユーザーがいるかどうか確認
                    if data.enterUser == uid{ //もし, ユーザーが入室していたら
                        self.enterButton.title = "退出" //退出ボタンを表示
                      
                        break
                    }
                    else{ //ユーザが退出していたら
                        self.enterButton.title = "入室" //入室ボタンを表示
                        //break
                    }
                    //print("配列:\(self.enterArray)")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

    }
    
    
    @IBAction func onClickEnterButton() {
        var iconName: String!
        let user = Auth.auth().currentUser
        if let user = user {//もし, ユーザー本人だったらFireStoreの部屋にユーザーを追加
            
            let uid = user.uid //ユーザーのID
            let userName = user.displayName
            for num in userName! {
                //print("数字:\(num)")
                iconName = String(num) //ユーザ名の頭文字を代入
                break
            }
            //print("ユーザー名：\(userName)")
            let RoomData = Firestore.firestore().collection("room").document(enterRoom).collection("enterUser")
            //もし, 部屋に誰もいなかったら
            if enterArray.isEmpty == true{
                self.enterArray = [Rooms]()
                RoomData.document(uid).setData(["enterUserID": uid, "enterUserName": userName]){ err in //FireStoreにユーザー本人を追加(入室)
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.enterButton.title = "退出"
                        //部屋にいるユーザーをenterArrayに格納し直し, TableViewを更新
                        self.EnterArray()
                    }
                }
                Firestore.firestore().collection("room").document(enterRoom).updateData(["iconNameArray": FieldValue.arrayUnion([iconName])])
            }
            
            //部屋に入室しているユーザーの中に本人がいるかどうか確認
            for data in enterArray{ //enterArray(部屋に入室しているユーザー)
                //print("配列：\(enterArray)")
                if data.enterUser == uid{ //部屋に本人のidがあったら消去
                    print("消去")
                    RoomData.document(uid).delete() { err in //FireStoreの部屋からユーザー本人を消去
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else { //消去に成功
                            print("Document successfully removed!")
                            self.enterButton.title = "入室"
                            //部屋にいるユーザーをenterArrayに格納し直し, TableViewを更新
                            self.EnterArray()
                        }
                    }
                    //print("数字:\(iconName)")
                    Firestore.firestore().collection("room").document(enterRoom).updateData(["iconNameArray": FieldValue.arrayRemove([iconName])])
                    break
                }
                else{ //部屋に本人のidがなかったらidを追加
                    print("追加")
                    RoomData.document(uid).setData(["enterUserID": uid, "enterUserName": userName]){ err in //Firestoreの部屋にユーザー本人を追加
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            self.enterButton.title = "退出"
                            //部屋にいるユーザーをenterArrayに格納し直し, TableViewに反映
                            self.EnterArray()
                        }
                    }
                    Firestore.firestore().collection("room").document(enterRoom).updateData(["iconNameArray": FieldValue.arrayUnion([iconName])])
                    //break
                }
            }//for文終わり
            
        }//if文終わり
        
    }
    
    //enterArrayに(部屋に入室しているユーザー)を格納、TableViewの更新
    func EnterArray(){
        let RoomData = Firestore.firestore().collection("room").document(enterRoom).collection("enterUser")
        RoomData.getDocuments{ (snapshots, err) in
            self.enterArray = [Rooms]()
            if let err = err{
                print("失敗")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
                let room = Rooms(document: snapshot)
                self.enterArray.append(room)
                //print("名前：\(room.enterName)")
            })
            DispatchQueue.main.async {
                self.addTableView.reloadData() //TableViewの更新
            }
        }
    }
    
}


extension AddViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        Firestore.firestore().collection("room").document(enterRoom).updateData(["roomEnterNum": String(enterArray.count)])
     
        return enterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! AddCustomTableViewCell
        var icon: String!
        var iconName: String!
      
        icon = enterArray[indexPath.row].enterName //ユーザー名
        for num in icon {
            //print(num)
            iconName = String(num) //ユーザ名の頭文字を代入
            break
        }
        // セルに値を設定
        cell.nameLabel.text = enterArray[indexPath.row].enterName
        cell.nameIconLabel.text = iconName //頭文字を表示
       
        //頭文字をFireStoreに保存
        Firestore.firestore().collection("room").document(enterRoom).collection("enterUser").document(enterArray[indexPath.row].enterUser).updateData(["iconName": iconName])
        
       // Firestore.firestore().collection("room").document(enterRoom).updateData(["iconNameArray": FieldValue.arrayUnion([iconName])])
        
        return cell
    }
    
    //セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           // performSegue(withIdentifier: "toAdd", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier=="toHome") {
                let vcHome = segue.destination as! HomeViewController;
                
                //iconArray = [Int]()
                //iconArray.append(enterArray.count)
                //vcHome.num = enterArray.count
                vcHome.setupMethod();
            }
        }
}


