//
//  colorViewController.swift
//  STYLiSH
//
//  Created by Hueijyun  on 2020/1/5.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit


protocol ColorViewControllerDelegate: AnyObject {
    func receiveData( data: String)
}

class ColorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: ColorViewControllerDelegate?
    
    @IBOutlet var chooseColorView: UIView!
    
    @IBOutlet var colorCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorCollection.dataSource = self
        colorCollection.delegate = self
        
    }
    
    let colorcode = ["DDF0FF", "CCCCCC", "334455", "FFFFFF", "FFDDDD", "DDFFBB", "BB7744"]
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }
    
    //最旁邊間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorcode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: colorcode[indexPath.item])
        cell.contentView.layer.borderWidth = 1
        
        //固定item邊框顏色
        cell.contentView.layer.borderColor = UIColor.hexStringToUIColor(hex: "AAAAAA").cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell1 = collectionView.cellForItem(at: indexPath){
            cell1.layer.borderWidth = 1
            cell1.layer.borderColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 1).cgColor
            cell1.isSelected = true
            delegate?.receiveData(data: colorcode[indexPath.item])
            //present as popover縮回去
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell1 = collectionView.cellForItem(at: indexPath){
            cell1.layer.borderWidth = 1
            cell1.layer.borderColor = UIColor.clear.cgColor
            cell1.isSelected = false
        }
    }
    
}
