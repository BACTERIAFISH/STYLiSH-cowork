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
    
    var status: String? {
        didSet {
            guard let status = status else { return }
            switch status {
            case "pending delivery":
                statusLabel.layer.borderColor = UIColor.hexStringToUIColor(hex: "A63D40").cgColor
                statusLabel.textColor = UIColor.hexStringToUIColor(hex: "A63D40")
                statusLabel.text = "待配送"
            case "delivering":
                statusLabel.layer.borderColor = UIColor.hexStringToUIColor(hex: "90A959").cgColor
                statusLabel.textColor = UIColor.hexStringToUIColor(hex: "90A959")
                statusLabel.text = "配送中"
            case "pending pickup":
                statusLabel.layer.borderColor = UIColor.hexStringToUIColor(hex: "6494AA").cgColor
                statusLabel.textColor = UIColor.hexStringToUIColor(hex: "6494AA")
                statusLabel.text = "待收貨"
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
