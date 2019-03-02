//
//  ProductListViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/19.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

protocol ProductListDataProvider {
    
    func fetchData(paging: Int, completion: @escaping ProductsResponseWithPaging)
}

class ProductListViewController: STCompondViewController {

    var provider: ProductListDataProvider?
    
    var paging: Int? = 0
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupTableView()
        
        setupCollectionView()
    }
    
    //MARK: - Private method
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.white
        
        tableView.lk_registerCellWithNib(
            identifier: String(describing: ProductTableViewCell.self),
            bundle: nil
        )
    }

    private func setupCollectionView() {
        
        collectionView.backgroundColor = UIColor.white
        
        collectionView.lk_registerCellWithNib(
            identifier: String(describing: ProductCollectionViewCell.self),
            bundle: nil
        )
        
        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(
            width: Int(164.0 / 375.0 * UIScreen.width) ,
            height: Int(164.0 / 375.0 * UIScreen.width * 308.0 / 164.0)
        )
        
        flowLayout.sectionInset = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
        
        flowLayout.minimumInteritemSpacing = 0
        
        flowLayout.minimumLineSpacing = 24.0
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    //MARK: - Override super class method
    override func headerLoader() {
        
        paging = 0
        
        datas = []
        
        resetNoMoreData()
        
        provider?.fetchData(paging: paging!, completion: { [weak self] result in
            
            self?.endHeaderRefreshing()
            
            switch result{
                
            case .success(let response):
                
                self?.datas = [response.data]
                
                self?.paging = response.paging
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        })
    }
    
    override func footerLoader() {
        
        guard let paging = paging else {
            
            endWithNoMoreData()
            
            return
        }
        
        provider?.fetchData(paging: paging, completion: { [weak self] result in
            
            self?.endFooterRefreshing()
            
            guard let strongSelf = self else { return }
            
            switch result{
                
            case .success(let response):
                
                guard let originalData = strongSelf.datas.first else { return }
                
                let newDatas = response.data
                
                self?.datas = [originalData + newDatas]
                
                self?.paging = response.paging
                
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
        
        guard let productCell = cell as? ProductTableViewCell,
              let product = datas[indexPath.section][indexPath.row] as? Product
        else {
            
            return cell
        }
        
        productCell.productImg.loadImage(product.main_image)
        
        productCell.productTitleLbl.text = product.title
        
        productCell.productPriceLbl.text = String(product.price)
        
        return productCell
    }
    
    //MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath
        )
        
        guard let productCell = cell as? ProductCollectionViewCell,
            let product = datas[indexPath.section][indexPath.row] as? Product
            else {
                
                return cell
        }
        
        productCell.productImg.loadImage(product.main_image)
        
        productCell.productTitleLbl.text = product.title
        
        productCell.productPriceLbl.text = String(product.price)
        
        return productCell
    }
}
