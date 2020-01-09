//
//  STTabBarViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

private enum Tab {

    case lobby

    case product

    case profile

    case trolley
    
    case filter

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .lobby: controller = UIStoryboard.lobby.instantiateInitialViewController()!

        case .product: controller = UIStoryboard.product.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        case .trolley: controller = UIStoryboard.trolley.instantiateInitialViewController()!
            
        case .filter: controller = UIStoryboard.filter.instantiateInitialViewController()!

        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .lobby:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Home_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Home_Selected)
            )

        case .product:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Catalog_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Catalog_Selected)
            )

        case .trolley:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Cart_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Cart_Selected)
            )

        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Profile_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Profile_Selected)
            )
            
        case .filter:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.icons8_search_36),
                selectedImage: UIImage.asset(.icons8_search_fill_36)
            )
        }
    }
}

class STTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.lobby, .product, .filter, .trolley, .profile]
    
    var trolleyTabBarItem: UITabBarItem!
    
    var orderObserver: NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        trolleyTabBarItem = viewControllers?[3].tabBarItem
        
        trolleyTabBarItem.badgeColor = .brown
        
        orderObserver = StorageManager.shared.observe(
            \StorageManager.orders,
            options: .new,
            changeHandler: { [weak self] _, change in
            
                guard let newValue = change.newValue else { return }
                
                if newValue.count > 0 {
                    
                    self?.trolleyTabBarItem.badgeValue = String(newValue.count)
                
                } else {
                
                    self?.trolleyTabBarItem.badgeValue = nil
                }
            }
        )
        
        StorageManager.shared.fetchOrders()
        
        delegate = self
    }

    // MARK: - UITabBarControllerDelegate

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {

        guard let navVC = viewController as? UINavigationController,
              navVC.viewControllers.first is ProfileViewController
        else { return true }

        guard KeyChainManager.shared.token != nil else {

            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {

                authVC.modalPresentationStyle = .overCurrentContext

                present(authVC, animated: false, completion: nil)
            }

            return false
        }

        return true
    }
}
