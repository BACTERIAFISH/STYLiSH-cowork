//
//  ChatTableViewCell.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/8.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class ChatServerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var serverImageView: UIImageView!
    
    @IBOutlet weak var serverView: UIView!
    
    @IBOutlet weak var severLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        serverImageView.layer.cornerRadius = 18
        serverImageView.layer.borderWidth = 1
        serverImageView.layer.borderColor = UIColor.B4?.cgColor
        
        serverView.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
