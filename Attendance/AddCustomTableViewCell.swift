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
        
        nameIconLabel.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        nameIconLabel.layer.borderWidth = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
