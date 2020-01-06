//
//  ShippingViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/5.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class ShippingViewController: UIViewController {
    
    @IBOutlet weak var shippingTableView: UITableView!
    
    private let userProvider = UserProvider()
    
    var orders = [WCOrder]() {
        didSet {
            shippingTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        shippingTableView.dataSource = self
        shippingTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        getOrder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func getOrder() {
        userProvider.ongoingOrder { [weak self] result in
            switch result {
            case .success(let wcOrders):
                self?.orders = wcOrders
            case .failure(let error):
                print("ongoing order error: \(error)")
            }
        }
    }
    
    func transferDate(second: Int) -> String {
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(second))
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}

extension ShippingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingTableViewCell", for: indexPath) as? ShippingTableViewCell else { return UITableViewCell() }
        
        cell.numberLabel.text = orders[indexPath.row].number
        cell.dateLabel.text = transferDate(second: orders[indexPath.row].time)
        cell.priceLabel.text = "NT$ \(orders[indexPath.row].details.total)"
        return cell
    }
    
}

extension ShippingViewController: UITableViewDelegate {
    
}
