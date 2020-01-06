//
//  ShippingTableViewCell.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/6.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class ShippingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
