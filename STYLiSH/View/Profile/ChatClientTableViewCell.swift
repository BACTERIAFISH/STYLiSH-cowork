//
//  ChatClientTableViewCell.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/8.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class ChatClientTableViewCell: UITableViewCell {

    @IBOutlet weak var clientImageView: UIImageView!
    
    @IBOutlet weak var clientView: UIView!
    
    @IBOutlet weak var clientLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        clientView.layer.cornerRadius = 5
        
        clientImageView.layer.cornerRadius = 18
        UserDataManager.shared.loadUser { [weak self] (user) in
            guard let strongSelf = self else { return }
            if let picture = user.picture {
                strongSelf.clientImageView.kf.setImage(with: URL(string: picture))
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
