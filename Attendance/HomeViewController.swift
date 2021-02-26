//
//  HomeViewController.swift
//  Attendance
//
//  Created by Mac on 2021/02/25.
//

import UIKit

class HomeViewController: UIViewController {

    private let cellid = "cellid"
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
}
    
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = homeTableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        
        return cell
    }
    
        
}
    
//cellにクラスを設定する
class HomeTableViewCell: UITableViewCell{
        
       
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        //TableView作成時に必要
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

