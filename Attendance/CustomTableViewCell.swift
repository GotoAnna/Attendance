//
//  CustomTableViewCell.swift
//  Attendance
//
//  Created by Mac on 2021/02/27.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var frameView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        frameView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
