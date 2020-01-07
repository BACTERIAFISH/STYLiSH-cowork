//
//  HistoryViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/5.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var nothingLabel: UILabel!
    
    private let userProvider = UserProvider()
    
    var orders = [WCOrder]() {
        didSet {
            if orders.isEmpty {
                historyTableView.isHidden = true
                nothingLabel.isHidden = false
            } else {
                nothingLabel.isHidden = true
                historyTableView.isHidden = false
                historyTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTableView.dataSource = self
        historyTableView.delegate = self
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
        if segue.identifier == "HistoryDetailSegue", let detailVC = segue.destination as? SHDetailViewController, let indexPath = historyTableView.indexPathForSelectedRow {
            detailVC.order = orders[indexPath.row]
        }
    }
    
    func getOrder() {
        userProvider.getOrder { [weak self] result in
            switch result {
            case .success(let wcOrders):
                self?.orders = wcOrders
            case .failure(let error):
                print("get history orders error: \(error)")
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

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        
        cell.numberLabel.text = orders[indexPath.row].number
        cell.dateLabel.text = transferDate(second: orders[indexPath.row].time)
        cell.priceLabel.text = "NT$ \(orders[indexPath.row].details.total)"
        return cell
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HistoryDetailSegue", sender: nil)
    }
}
