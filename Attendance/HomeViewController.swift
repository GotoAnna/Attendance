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
    var back: Int = 0
    //var icon = [String]()
    //var icon = AddViewController()
    
    @IBOutlet weak var homeTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                //print(room.roomName)
                //print(room.roomNumber)
                print("人数：\(room.roomEnterNum)")
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
        //print("人数：\(roomsArray[indexPath.row].enterNum)")
        cell.enterNum.text = String(roomsArray[indexPath.row].roomEnterNum)
        
        
        let label1 = UILabel()
        label1.backgroundColor = UIColor.blue
        label1.textColor = UIColor.white
        label1.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.layer.cornerRadius = 25
        label1.clipsToBounds = true
        label1.text = ""
        
        let label2 = UILabel()
        label2.backgroundColor = UIColor.blue
        label2.textColor = UIColor.white
        label2.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.layer.cornerRadius = 25
        label2.clipsToBounds = true
        
        cell.stackView.addArrangedSubview(label1)
        cell.stackView.addArrangedSubview(label2)
        
        return cell
    }
    
    //セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            num = indexPath.row
            //print("部屋名:\(roomsArray[indexPath.row].roomName!)")
            performSegue(withIdentifier: "toAdd", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toAdd") {
           
            let next: AddViewController = (segue.destination as? AddViewController)!
            
            next.enterRoom = roomsArray[num].roomName
        }
    }
    
    func setupMethod(){}
    @IBAction func myUnwindAction(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        if(unwindSegue.identifier=="toHome"){
            
            print("戻る\(back)")
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
