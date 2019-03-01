//
//  ProductListViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/19.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

typealias ProductsResponse = (Result<[Product]>) -> Void

protocol ProductListDataProvider {
    
    func fetchData(completion: @escaping ProductsResponse)
}

class ProductListViewController: STCompondViewController {

    var provider: ProductListDataProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableViewCell()
        
        registerCollectionCell()
        
        setupCollectionViewLayout()
        
        datas = [[1, 2, 3, 4, 5, 6, 7]]
    
        collectionView.isHidden = true
    }
    
    private func registerTableViewCell() {
        
        tableView.lk_registerCellWithNib(
            identifier: String(describing: ProductTableViewCell.self),
            bundle: nil
        )
    }

    private func registerCollectionCell() {
        
        collectionView.lk_registerCellWithNib(
            identifier: String(describing: ProductCollectionViewCell.self),
            bundle: nil
        )
    }
    
    private func setupCollectionViewLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(
            width: Int(164.0 / 375.0 * UIScreen.width) ,
            height: Int(164.0 / 375.0 * UIScreen.width * 220.0 / 164.0)
        )
        
        flowLayout.sectionInset = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
        
        flowLayout.minimumInteritemSpacing = 0
        
        flowLayout.minimumLineSpacing = 24.0
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    override func tableViewHeaderLoader() {
        
        provider?.fetchData(completion: { [weak self] result in
            
            switch result{
                
            case .success(let products):
                
                self?.datas = [products]
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        })
    }
    
    //MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ProductTableViewCell.self),
            for: indexPath
        )
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    //MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath
        )
    
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
}
