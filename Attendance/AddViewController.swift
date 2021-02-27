//
//  AddViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/27.
//

import UIKit

class AddViewController: UIViewController {

    private let cellid = "cellid"
    let nameTitles = ["後藤 杏奈", "A子", "B子"]
    //let image = ["6人", "8人", "10人"]
    
    @IBOutlet weak var addTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTableView.delegate = self
        addTableView.dataSource = self
    }
}

extension AddViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! AddCustomTableViewCell
           
           // セルに値を設定
        cell.nameLabel.text = nameTitles[indexPath.row]
        
        return cell
    }
}
