//
//  FilterTableViewCell.swift
//  STYLiSH
//
//  Created by Hueijyun  on 2020/1/5.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

   
    @IBOutlet var catalogPrice: UILabel!
    @IBOutlet var catalogTitle: UILabel!
    @IBOutlet var catalogImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
