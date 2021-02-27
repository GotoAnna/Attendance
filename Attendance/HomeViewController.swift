//
//  HomeViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/25.
//

import UIKit

class HomeViewController: UIViewController {

    private let cellid = "cellid"
    
    let createRoom = CreateRoomViewController()
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        if UserDefaults.standard.object(forKey: "RoomName") != nil{
             
            //createRoom.roomnameArray = UserDefaults.standard.object(forKey: "RoomName") as! [String]
            roomnameArray = UserDefaults.standard.object(forKey: "RoomName") as! [String]
         }
        if UserDefaults.standard.object(forKey: "RoomNumber") != nil{
             
            //createRoom.roomnumberArray = UserDefaults.standard.object(forKey: "RoomNumber") as! [String]
            roomnumberArray = UserDefaults.standard.object(forKey: "RoomNumber") as! [String]
         }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            homeTableView.reloadData() //TableViewの更新
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return createRoom.roomnameArray.count
        return roomnameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! CustomTableViewCell
        
        cell.roomLabel.text = roomnameArray[indexPath.row]
        cell.numberLabel.text = roomnumberArray[indexPath.row]
        //cell.roomLabel.text = createRoom.roomnameArray[indexPath.row]
        //cell.numberLabel.text = createRoom.roomnumberArray[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
            performSegue(withIdentifier: "toAdd", sender: nil)
    }
        
}
 

