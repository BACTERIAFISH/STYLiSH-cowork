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
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var url: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let url = url else { return }
        serverImageView.kf.setImage(with: URL(string: url))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
