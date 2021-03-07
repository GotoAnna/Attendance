//
//  HomeViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/25.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    private let cellid = "cellid"
    var roomsArray = [Rooms]()
    var array = [Rooms]()
    var enterArray = [Rooms]()
    var iconArray = [Rooms]()
    var nameArray = [String]()
    let createRoom = CreateRoomViewController()
    var roomname: String!
    var num: Int = 0
    var back: Int = 0
    var number: Int = 0
    @IBOutlet weak var homeTableView: UITableView!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var createLabel: UIButton!
    
    var trashButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTableView.delegate = self
        homeTableView.dataSource = self
        createButton.layer.cornerRadius = 30
        
        self.navigationItem.title = "Title"
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.392, green: 0.972, blue: 0.972, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.392, green: 0.972, blue: 0.972, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.black
      
        createLabel.layer.borderWidth = 3.0    // 枠線の幅
        createLabel.layer.borderColor = UIColor.init(red: 0.474, green: 0.835, blue: 0.870, alpha: 1).cgColor
    
        createButton.layer.shadowOpacity = 0.5
        createButton.layer.shadowRadius = 5
        createButton.layer.shadowColor = UIColor.black.cgColor
        createButton.layer.shadowOffset = CGSize(width: 5, height: 5)
     /*   array = [Rooms]()
        Firestore.firestore().collection("room").getDocuments{ (snapshots, err) in
            if let err = err{
                print("失敗")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
               // let dic = snapshot.data()
                let room = Rooms(document: snapshot)
                self.array.append(room)
                print("ICON:\(room.iconNameArray)")
            })
            DispatchQueue.main.async {
                self.homeTableView.reloadData() //TableViewの更新
                //print("配列：\(Attendance.Rooms.self)")
            }
            print("部屋配列：\(self.array)")
            for data in self.array{
                self.enterArray = [String]()
                let RoomData = Firestore.firestore().collection("room").document(data.roomName).collection("enterUser")
                RoomData.getDocuments{ (snapshots, err) in
                    //self.enterArray = [String]()
                    print("DID")
                    if let err = err{
                        print("失敗")
                        return
                    }
                    snapshots?.documents.forEach({ (snapshot) in
                        let room = Rooms(document: snapshot)
                        self.enterArray.append(room.iconName)
                        print("名前:\(room.iconName)")
                        //print("名前：\(room.enterName)")
                    })
                }
                //Firestore.firestore().collection("room").document(data.roomName).updateData(["iconNameArray": FieldValue.arrayUnion(["iconName"])])
            }
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
        print("back:\(back)")
        roomsArray = [Rooms]()
        
        Firestore.firestore().collection("room").getDocuments{ (snapshots, err) in
            if let err = err{
                print("失敗")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
               // let dic = snapshot.data()
                let room = Rooms(document: snapshot)
                self.roomsArray.append(room)
                print("ICON:\(room.iconNameArray)")
            })
            DispatchQueue.main.async {
                self.homeTableView.reloadData() //TableViewの更新
                //print("配列：\(Attendance.Rooms.self)")
            }
        }
    }

    @IBAction func trashButton(_ sender: Any) {
        trashButtonTapped(homeTableView)
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return roomsArray.count
    }
    //セルに内容を表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! CustomTableViewCell
        
        cell.roomLabel.text = roomsArray[indexPath.row].roomName
        cell.numberLabel.text = roomsArray[indexPath.row].roomNumber
        roomname = roomsArray[indexPath.row].roomName
        //cell.enterNum.text = roomsArray[indexPath.row].roomEnterNum
        
        if roomsArray[indexPath.row].roomEnterNum == ""{
            number = 0
            cell.enterNum.text = "0"
        }
        else{
            cell.enterNum.text = roomsArray[indexPath.row].roomEnterNum
            number = Int(roomsArray[indexPath.row].roomEnterNum)!
        }
      
        let db = Firestore.firestore().collection("room").document(roomsArray[indexPath.row].roomName) //部屋名
        iconArray = [Rooms]()
        db.collection("enterUser").getDocuments{ (snapshots, err) in //FireStoreから名前の頭文字を取得
            if let err = err{
                print("失敗")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
                let room = Rooms(document: snapshot)
                self.iconArray.append(room)
                print("ICON:\(room.iconName)")
            })
        }
        
        cell.icon1.isHidden = false
        cell.icon2.isHidden = false
        cell.icon3.isHidden = false
        cell.icon4.isHidden = false
        cell.icon5.isHidden = false
        cell.icon6.isHidden = false
       
        if number == 0{
            cell.icon1.isHidden = true
            cell.icon2.isHidden = true
            cell.icon3.isHidden = true
            cell.icon4.isHidden = true
            cell.icon5.isHidden = true
            cell.icon6.isHidden = true
        }
        if number == 1{
            cell.icon1.text = roomsArray[indexPath.row].iconNameArray[0]
            cell.icon2.isHidden = true
            cell.icon3.isHidden = true
            cell.icon4.isHidden = true
            cell.icon5.isHidden = true
            cell.icon6.isHidden = true
        }
        if number == 2{
            cell.icon1.text = roomsArray[indexPath.row].iconNameArray[0]
            cell.icon2.text = roomsArray[indexPath.row].iconNameArray[1]
            cell.icon3.isHidden = true
            cell.icon4.isHidden = true
            cell.icon5.isHidden = true
            cell.icon6.isHidden = true
        }
        if number == 3{
            cell.icon1.text = roomsArray[indexPath.row].iconNameArray[0]
            cell.icon2.text = roomsArray[indexPath.row].iconNameArray[1]
            cell.icon3.text = roomsArray[indexPath.row].iconNameArray[2]
            cell.icon4.isHidden = true
            cell.icon5.isHidden = true
            cell.icon6.isHidden = true
        }
        if number == 4{
            cell.icon1.text = roomsArray[indexPath.row].iconNameArray[0]
            cell.icon2.text = roomsArray[indexPath.row].iconNameArray[1]
            cell.icon3.text = roomsArray[indexPath.row].iconNameArray[2]
            cell.icon4.text = roomsArray[indexPath.row].iconNameArray[3]
            cell.icon5.isHidden = true
            cell.icon6.isHidden = true
        }
        if number == 5{
            cell.icon1.text = roomsArray[indexPath.row].iconNameArray[0]
            cell.icon2.text = roomsArray[indexPath.row].iconNameArray[1]
            cell.icon3.text = roomsArray[indexPath.row].iconNameArray[2]
            cell.icon4.text = roomsArray[indexPath.row].iconNameArray[3]
            cell.icon5.text = roomsArray[indexPath.row].iconNameArray[4]
            cell.icon6.isHidden = true
        }
        if number == 6{
            cell.icon1.text = roomsArray[indexPath.row].iconNameArray[0]
            cell.icon2.text = roomsArray[indexPath.row].iconNameArray[1]
            cell.icon3.text = roomsArray[indexPath.row].iconNameArray[2]
            cell.icon4.text = roomsArray[indexPath.row].iconNameArray[3]
            cell.icon5.text = roomsArray[indexPath.row].iconNameArray[4]
            cell.icon6.isHidden = false
        }
      
        return cell
    }
    
    //セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            num = indexPath.row
            performSegue(withIdentifier: "toAdd", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toAdd") {
           
            let next: AddViewController = (segue.destination as? AddViewController)!
            
            next.enterRoom = roomsArray[num].roomName
        }
    }
    
    func setupMethod(){}
    @IBAction func myUnwindAction(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController)
    {
        if(unwindSegue.identifier=="toHome"){
            
               }
    }

    //編集モード
    
    @objc func trashButtonTapped(_ tableView: UITableView){
        if(tableView.isEditing == true)
        {
            tableView.isEditing = false //編集不可
            print("編集可能")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:  .trash, target: self, action: #selector(self.trashButton))
            //EditButton.title = "Edit"
        }
        else{
            tableView.isEditing = true //編集可
            //EditButton.title = "Done"
            print("編集不可")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:  .done, target: self, action: #selector(self.trashButton))
        }
    }
    
    @objc func edit() {
           print("Push searchButton")
       }

    //編集モードの時のみ消去できるようにする
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
    
        return .none
    }
    
    //セルの消去
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == UITableViewCell.EditingStyle.delete {
               
                print("消去部屋名:\(roomsArray[indexPath.row].roomName!)")
                
        
                    //self.enterArray = [Rooms]()
         /*       let RoomData = Firestore.firestore().collection("room").document(roomsArray[indexPath.row].roomName).collection("enterUser")
                RoomData.getDocuments{ (snapshots, err) in
                //self.enterArray = [String]()
                    print("DID")
                    if let err = err{
                        print("失敗")
                        return
                    }
                    snapshots?.documents.forEach({ (snapshot) in
                            let room = Rooms(document: snapshot)
                            //self.enterArray.append(room)
                            //print("名前:\(room.enterUser)")
                            Firestore.firestore().collection("room").document(self.roomsArray[indexPath.row].roomName).collection("enterUser").document(room.enterUser).delete() { err in
                                print("ユーザー")
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("ユーザーを消去")
                                    print("名前:\(room.enterUser)")
                                }
                            }
                        })
                    }*/
                
               /* Firestore.firestore().collection("room").document(self.roomsArray[indexPath.row].roomName).collection("enterUser").document(roomsArray[indexPath.row].enterUser).delete() { err in
                    print("ユーザー")
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("ユーザーを消去")
                    }
                }*/
                
            /*    for data in enterArray{
                    Firestore.firestore().collection("room").document(roomsArray[indexPath.row].roomName).collection("enterUser").document(data.enterUser).delete() { err in
                        print("ユーザー")
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("ユーザーを消去")
                        }
                    }
                }*/
                
               Firestore.firestore().collection("room").document(roomsArray[indexPath.row].roomName).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("部屋名を消去")
                    }
                }
                    
                roomsArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            }
    }
}
