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
    
    @IBOutlet weak var nothingLabel: UILabel!
        
    private let userProvider = UserProvider()
    
    var orders = [WCOrder]() {
        didSet {
            if orders.isEmpty {
                shippingTableView.isHidden = true
                nothingLabel.isHidden = false
            } else {
                nothingLabel.isHidden = true
                shippingTableView.isHidden = false
                shippingTableView.reloadData()
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShippingDetailSegue", let detailVC = segue.destination as? SHDetailViewController, let indexPath = shippingTableView.indexPathForSelectedRow {
            detailVC.order = orders[indexPath.row]
        }
    }
    
    func getOrder() {
        userProvider.ongoingOrder { [weak self] result in
            switch result {
            case .success(let wcOrders):
                self?.orders = wcOrders
            case .failure(let error):
                self?.orders = []
                print("ongoing order error: \(error)")
            }
        }
    }
    
    func transferDate(second: Int) -> String {
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(second/1000))
        formatter.dateFormat = "yyyy/MM/dd\nhh:mm:ss"
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
        cell.status = orders[indexPath.row].logistics
        return cell
    }
    
}

extension ShippingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShippingDetailSegue", sender: nil)
    }
}
