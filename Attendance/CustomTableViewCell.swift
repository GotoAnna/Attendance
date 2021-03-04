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
    
    @IBOutlet weak var enterNum: UILabel!
    
    
    @IBOutlet weak var stackView: UIStackView!
    
    let label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        frameView.layer.cornerRadius = 10
        stackView.spacing = 10

        label.backgroundColor = UIColor.blue
        label.textColor = UIColor.white
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 25
        label.clipsToBounds = true
        
        label.layer.borderWidth = 2.0
        label.layer.borderColor = UIColor.red.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
