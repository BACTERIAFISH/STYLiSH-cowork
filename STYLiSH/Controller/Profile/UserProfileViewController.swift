//
//  UserProfileViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/5.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userTableView: UITableView!
    
    let titleList = ["Email", "生日", "購物金"]
    
    var profile: Profile? {
        didSet {
            guard let profile = profile else { return }
            if let picture = profile.picture {
                userImageView.kf.setImage(with: URL(string: picture))
            }
            nameLabel.text = profile.name
            userTableView.reloadData()
        }
    }
    
    let userProvider = UserProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProvider.getProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                print(profile)
            case .failure(let error):
                print("get profile error: \(error)")
            }
        }
        
        userTableView.dataSource = self
        userTableView.delegate = self
        
        userImageView.layer.cornerRadius = 30
    }
    
}

extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileTableViewCell") as? UserProfileTableViewCell, let profile = profile else { return UITableViewCell() }
        
        cell.titleLabel.text = titleList[indexPath.row]
        switch indexPath.row {
        case 0: cell.contentLabel.text = profile.email
        case 1: cell.contentLabel.text = profile.birthday
        case 2: cell.contentLabel.text = String(profile.points)
        default: break
        }
        
        return cell
    }
    
}
