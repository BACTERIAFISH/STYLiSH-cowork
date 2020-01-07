//
//  FavoriteViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/7.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var favorites = [SCFavorite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        
        favoriteTableView.lk_registerCellWithNib(
            identifier: String(describing: ProductTableViewCell.self),
            bundle: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        getFavorite()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func getFavorite() {
        StorageManager.shared.fetchFavorites { result in
            switch result {
            case .success(let scFavorites):
                favorites = scFavorites
                favoriteTableView.reloadData()
            case .failure(let error):
                print("get favorite error: \(error)")
            }
        }
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ProductTableViewCell.self),
            for: indexPath
        )

        guard
            let productCell = cell as? ProductTableViewCell,
            let lsProduct = favorites[indexPath.row].product,
            let product = Product.convert(lsProduct: lsProduct)
        else {
            return cell
        }

        productCell.layoutCell(
            image: product.mainImage,
            title: product.title,
            price: product.price
        )

        return productCell
    }
    
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            StorageManager.shared.deleteFavorite(favorite: favorites[indexPath.row]) { result in
                switch result {
                case .success:
                    favorites.remove(at: indexPath.row)
                    favoriteTableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    print("delete favorite error: \(error)")
                }
            }
        }
    }
}
