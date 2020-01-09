//
//  ChatServerImageTableViewCell.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/9.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class ChatServerImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var serverImageView: UIImageView!
    
    @IBOutlet weak var serverUserImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var url: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        serverUserImageView.layer.cornerRadius = 18
        serverUserImageView.layer.borderWidth = 1
        serverUserImageView.layer.borderColor = UIColor.B4?.cgColor
        
        guard let url = url else { return }
        serverImageView.kf.setImage(with: URL(string: url))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
