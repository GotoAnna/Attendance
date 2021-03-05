//
//  HomeViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/25.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    private let cellid = "cellid"
    var roomsArray = [Rooms]()
    var iconArray = [Rooms]()
   // var copyIconArray = [Rooms]()
    let createRoom = CreateRoomViewController()
    var roomname: String!
    var num: Int = 0
    var back: Int = 0
    var number: Int = 0
    @IBOutlet weak var homeTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTableView.delegate = self
        homeTableView.dataSource = self
        
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
        cell.enterNum.text = roomsArray[indexPath.row].roomEnterNum
        number = Int(roomsArray[indexPath.row].roomEnterNum)!
        
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
            cell.icon6.isHidden = true
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
    
    
    //セルの消去
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == UITableViewCell.EditingStyle.delete {
               
                print("消去部屋名:\(roomsArray[indexPath.row].roomName!)")
                
                Firestore.firestore().collection("room").document(roomsArray[indexPath.row].roomName).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                    
                roomsArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            }
    }
}
