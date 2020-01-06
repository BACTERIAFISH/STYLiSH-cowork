//
//  ShippingViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/5.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class ShippingViewController: UIViewController {
    
    private let userProvider = UserProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        userProvider.ongoingOrder { result in
            switch result {
            case .success(let orders):
                print(orders)
            case .failure(let error):
                print("ongoing order error: \(error)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
