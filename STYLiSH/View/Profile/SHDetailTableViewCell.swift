//
//  SHDetailTableViewCell.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/7.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class SHDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var qtyLabel: UILabel!
    
    var list: OrderListObject? {
        didSet {
            guard let list = list else { return }
            nameLabel.text = list.name
            colorView.backgroundColor = UIColor.hexStringToUIColor(hex: list.color.code)
            sizeLabel.text = list.size
            qtyLabel.text = String(list.qty)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.B1?.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
