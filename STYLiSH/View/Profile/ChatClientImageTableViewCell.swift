//
//  ChatClientImageTableViewCell.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/9.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class ChatClientImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clientUserImageView: UIImageView!
    
    @IBOutlet weak var clientImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var url: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        clientImageView.layer.cornerRadius = 18
        UserDataManager.shared.loadUser { [weak self] (user) in
            guard let strongSelf = self else { return }
            if let picture = user.picture {
                strongSelf.clientUserImageView.kf.setImage(with: URL(string: picture))
            }
        }
        
        guard let url = url else { return }
        clientImageView.kf.setImage(with: URL(string: url))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
