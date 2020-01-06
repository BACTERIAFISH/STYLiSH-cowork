//
//  HistoryViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/5.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    private let userProvider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userProvider.getOrder { [weak self] result in
            switch result {
            case .success(let orders):
                print(orders)
            case .failure(let error):
                print("get history orders error: \(error)")
            }
        }
    }

}
