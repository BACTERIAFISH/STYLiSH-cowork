//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

            collectionView.delegate = self

            collectionView.dataSource = self
        }
    }

    let manager = ProfileManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDataManager.shared.loadUser { [weak self] (user) in
            guard let strongSelf = self else { return }
            strongSelf.userNameLabel.text = user.name
            if let picture = user.picture {
                strongSelf.userImageView.kf.setImage(with: URL(string: picture))
            } else {
                strongSelf.userImageView.image = UIImage.asset(.profile_sticker_placeholder01)
            }
        }
    }

    @IBAction func signOut(_ sender: UIButton) {
        KeyChainManager.shared.removeServerTokenKey()
        UserDataManager.shared.removeUser()
        tabBarController?.selectedIndex = 0
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return manager.groups.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return manager.groups[section].items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
            for: indexPath
        )

        guard let profileCell = cell as? ProfileCollectionViewCell else { return cell }

        let item = manager.groups[indexPath.section].items[indexPath.row]

        profileCell.layoutCell(image: item.image, text: item.title)

        return profileCell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {

            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: ProfileCollectionReusableView.self),
                for: indexPath
            )

            guard let profileView = header as? ProfileCollectionReusableView else { return header }

            let group = manager.groups[indexPath.section]

            profileView.layoutView(title: group.title, actionText: group.action?.title)

            return profileView
        }

        return UICollectionReusableView()
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if indexPath.section == 0 {

            return CGSize(width: UIScreen.width / 4.0, height: 60.0)

        } else if indexPath.section == 1 {

            return CGSize(width: UIScreen.width / 4.0, height: 60.0)
        }

        return CGSize.zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {

        return UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {

        return 24.0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {

        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {

        return CGSize(width: UIScreen.width, height: 48.0)
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                performSegue(withIdentifier: "ShippingSegue", sender: nil)
            } else if indexPath.item == 1 {
                performSegue(withIdentifier: "HistorySegue", sender: nil)
            }
            
        } else if indexPath.section == 1 {
            switch indexPath.item {
            case 0:
                performSegue(withIdentifier: "UserProfileSegue", sender: nil)
            case 1:
                performSegue(withIdentifier: "FavoriteSegue", sender: nil)
            case 2:
                performSegue(withIdentifier: "ClientServiceSegue", sender: nil)
            default:
                break
            }
        }
    }

}
