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
    
    @IBOutlet weak var frameShadowView: UIView!
    
    @IBOutlet weak var enterNum: UILabel!
    
    @IBOutlet weak var aLabel: UILabel!
   
    @IBOutlet weak var bLabel: UILabel!
    
    @IBOutlet weak var icon1: UILabel!
    
    @IBOutlet weak var icon2: UILabel!
    
    @IBOutlet weak var icon3: UILabel!
    
    @IBOutlet weak var icon4: UILabel!
    
    @IBOutlet weak var icon5: UILabel!
    
    @IBOutlet weak var icon6: UILabel!
    
    /* let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    let label4 = UILabel()
    let label5 = UILabel()*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        frameView.layer.cornerRadius = 10
        
        frameShadowView.layer.cornerRadius = 10
        frameShadowView.layer.shadowOpacity = 0.4
        frameShadowView.layer.shadowRadius = 5
        frameShadowView.layer.shadowColor = UIColor.black.cgColor
        frameShadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        //stackView.spacing = 10
        
        
        icon1.layer.cornerRadius = 25
        icon1.clipsToBounds = true
        icon2.layer.cornerRadius = 25
        icon2.clipsToBounds = true
        icon3.layer.cornerRadius = 25
        icon3.clipsToBounds = true
        icon4.layer.cornerRadius = 25
        icon4.clipsToBounds = true
        icon5.layer.cornerRadius = 25
        icon5.clipsToBounds = true
    
        icon1.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        icon1.layer.borderWidth = 2
        icon2.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        icon2.layer.borderWidth = 2
        icon3.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        icon3.layer.borderWidth = 2
        icon4.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        icon4.layer.borderWidth = 2
        icon5.layer.borderColor = UIColor.init(red: 0.364, green: 0.450, blue: 0.917, alpha: 1).cgColor
        icon5.layer.borderWidth = 2
        
        enterNum.textColor = UIColor.black
        aLabel.textColor = UIColor.black
        bLabel.textColor = UIColor.black
        roomLabel.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
