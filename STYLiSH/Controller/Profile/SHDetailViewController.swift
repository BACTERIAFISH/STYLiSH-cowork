//
//  ShippingDetailViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/7.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class SHDetailViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var paymentLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var pointsUsedLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var listTableView: UITableView!
    
    var order: WCOrder?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        listTableView.dataSource = self
        listTableView.delegate = self
        
        guard let order = order else { return }
        numberLabel.text = order.number
        timeLabel.text = transferDate(second: order.time)
        paymentLabel.text = order.details.payment == "cash" ? "貨到付款" : "信用卡付款"
        priceLabel.text = "NT$ \(order.details.subtotal)"
        pointsUsedLabel.text = String(order.pointsUsed)
        pointsLabel.text = String(order.points)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func transferDate(second: Int) -> String {
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(second/1000))
        formatter.dateFormat = "yyyy/MM/dd\nhh:mm:ss"
        return formatter.string(from: date)
    }

}

extension SHDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.details.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let order = order, let cell = tableView.dequeueReusableCell(withIdentifier: "SHDetailTableViewCell", for: indexPath) as? SHDetailTableViewCell else { return UITableViewCell() }
        
        cell.list = order.details.list[indexPath.row]
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor.B5
        } else {
            cell.backgroundColor = .white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "物品清單"
    }
}

extension SHDetailViewController: UITableViewDelegate {
    
}
