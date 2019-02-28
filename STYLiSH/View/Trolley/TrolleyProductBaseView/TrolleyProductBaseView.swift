//
//  TrolleyProductBaseView.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/28.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

protocol TrolleyProductBaseViewModel {
    
    var troTitle: String { get }
    
    var troSize: String { get }

    var troPrice: String { get }
    
    var troColor: UIColor { get }
}

class TrolleyProductBaseView: UIView {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var sizeLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    var touchHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initContentView()
    }
    
    private func initContentView() {
        
        backgroundColor = UIColor.white
        
        Bundle.main.loadNibNamed(
            String(describing: TrolleyProductBaseView.self),
            owner: self,
            options: nil
        )
        
        stickSubView(contentView)
    }
    
    @IBAction func didTouchRemoveButton(_ sender: UIButton) {
    
        touchHandler?()
    }
    
    func layoutView(model: TrolleyProductBaseViewModel) {
        
        titleLbl.text = model.troTitle
        
        sizeLbl.text = model.troSize
        
        priceLbl.text = model.troPrice
        
        colorView.backgroundColor = model.troColor
    }

}
