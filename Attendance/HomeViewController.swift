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
    
    let createRoom = CreateRoomViewController()
    var roomname: String!
    var num: Int = 0
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
            
      /*  if UserDefaults.standard.object(forKey: "RoomName") != nil{
             
            //createRoom.roomnameArray = UserDefaults.standard.object(forKey: "RoomName") as! [String]
            roomnameArray = UserDefaults.standard.object(forKey: "RoomName") as! [String]
         }
        if UserDefaults.standard.object(forKey: "RoomNumber") != nil{
             
            //createRoom.roomnumberArray = UserDefaults.standard.object(forKey: "RoomNumber") as! [String]
            roomnumberArray = UserDefaults.standard.object(forKey: "RoomNumber") as! [String]
         }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
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
                print(room.roomName)
                print(room.roomNumber)
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
        
        //return createRoom.roomnameArray.count
        return roomsArray.count
    }
    
    //セルに内容を表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! CustomTableViewCell
        
        cell.roomLabel.text = roomsArray[indexPath.row].roomName
        cell.numberLabel.text = roomsArray[indexPath.row].roomNumber
        roomname = roomsArray[indexPath.row].roomName
        //cell.roomLabel.text = createRoom.roomnameArray[indexPath.row]
        //cell.numberLabel.text = createRoom.roomnumberArray[indexPath.row]
        
        return cell
    }
    
    //セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            num = indexPath.row
            print("部屋名:\(roomsArray[indexPath.row].roomName!)")
            performSegue(withIdentifier: "toAdd", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toAdd") {
           
            let next: AddViewController = (segue.destination as? AddViewController)!
            
            next.enterRoom = roomsArray[num].roomName
            
            //print("入室prepare")
           // print("入室\(next.enterRoom)")
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
                    
                //消去した内容を保存
                //UserDefaults.standard.set(self.roomsArray, forKey: "RoomName")
                //UserDefaults.standard.set(roomsArray, forKey: "RoomNumber")
             
    }
        
}
 
}
