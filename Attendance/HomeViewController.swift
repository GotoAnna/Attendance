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
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

      
        createLabel.layer.borderWidth = 3.0    // 枠線の幅
        createLabel.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
    
        createButton.layer.shadowOpacity = 0.5
        createButton.layer.shadowRadius = 5
        createButton.layer.shadowColor = UIColor.black.cgColor
        createButton.layer.shadowOffset = CGSize(width: 5, height: 5)
           
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
        
        if roomsArray[indexPath.row].roomEnterNum == roomsArray[indexPath.row].roomNumber{
            cell.frameView.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
            cell.frameView.layer.borderWidth = 5
        }
        else{
            cell.frameView.layer.borderWidth = 0
        }
        
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
            next.roomNumber = roomsArray[num].roomNumber
            next.roomEnterNum = roomsArray[num].roomEnterNum
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
                print("消去人数:\(Int(roomsArray[indexPath.row].roomEnterNum))")
                if Int(roomsArray[indexPath.row].roomEnterNum) == 0{
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
                else{
                    let alert: UIAlertController = UIAlertController(title:"警告", message: "入室しているユーザーがいるため消去できません。", preferredStyle: .alert)
                    
                    //OKボタン
                    alert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .default,
                            handler: {action in
                                //self.navigationController?.popViewController(animated: true) //ボタンが押された時の動作
                                print("OKボタンが押されました！")
                            })
                    )
                    present(alert, animated: true, completion: nil)
                }
              
            }
    }
}
