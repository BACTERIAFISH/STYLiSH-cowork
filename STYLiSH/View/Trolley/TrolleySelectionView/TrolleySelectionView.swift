//
//  TrolleySelectionView.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/28.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class TrolleySelectionView: UIView, UITextFieldDelegate {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var substractBtn: UIButton!
    
    @IBOutlet weak var inputField: UITextField! {
        
        didSet {
            
            inputField.keyboardType = .numberPad
            
            inputField.delegate = self
        }
    }
    
    private var maxNumber: Int? {
 
        didSet {
            checkData()
        }
    }
    
    private var inputViews: [UIControl] {
        
        return [addBtn, substractBtn, inputField]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    private func initView() {
        
        backgroundColor = UIColor.white
        
        Bundle.main.loadNibNamed(
            String(describing: TrolleySelectionView.self),
            owner: self,
            options: nil
        )
        
        stickSubView(contentView)
    }

    @IBAction func addAmount(_ sender: UIButton) {
        
        guard let text = inputField.text,
              let amount = Int(text)
        else { return }
        
        inputField.text = String(amount + 1)
        
        checkData()
    }
    
    @IBAction func subtractAmount(_ sender: UIButton) {
        
        guard let text = inputField.text,
            let amount = Int(text)
            else { return }
        
        inputField.text = String(amount - 1)
        
        checkData()
    }
    
    func isEnable(_ flag: Bool, maxNumber: Int?) {
        
        if flag {
            
            inputViews.forEach({ item in
                
                enable(item: item)
            })
            
            inputField.text = "1"
            
            disable(item: substractBtn)
            
        } else {
            
            inputViews.forEach({ item in
                
                disable(item: item)
            })
            
            inputField.text = ""
        }
        
        self.maxNumber = maxNumber
    }
    
    func checkData() {
        
        guard let maxNumber = maxNumber else { return }
        
        guard let text = inputField.text,
              let input = Int(text),
              input <= maxNumber,
              input > 0
        else {
            
            inputField.text = String(maxNumber)
            
            disable(item: addBtn)
            
            enable(item: substractBtn)
            
            return
        }
        
        if input == maxNumber {
            
            disable(item: addBtn)
            
            enable(item: substractBtn)
        
            return
        }
        
        if input == 1 {
            
            enable(item: addBtn)
            
            disable(item: substractBtn)
            
            return
        }
        
        enable(item: addBtn)
        
        enable(item: substractBtn)
        
    }
    
    private func disable(item: UIControl) {
        
        item.layer.borderColor = UIColor.B1?.withAlphaComponent(0.4).cgColor
        
        item.tintColor = UIColor.B1?.withAlphaComponent(0.4)
        
        item.isEnabled = false
    }
    
    private func enable(item: UIControl) {
        
        item.layer.borderColor = UIColor.B1?.cgColor
        
        item.tintColor = UIColor.B1
        
        item.isEnabled = true
    }
    
    //MARK : - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkData()
    }
}
