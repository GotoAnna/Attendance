//
//  AddCustomTableViewCell.swift
//  Attendance
//
//  Created by Mac on 2021/02/27.
//

import UIKit

class AddCustomTableViewCell: UITableViewCell {

    //@IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameIconLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameIconLabel.layer.cornerRadius = 25
        nameIconLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
