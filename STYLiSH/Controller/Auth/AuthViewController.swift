//
//  AuthViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/15.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class AuthViewController: STBaseViewController {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let userProvider = UserProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        // contentView.isHidden = true
        
        contentViewBottomConstraint.constant = contentView.frame.height
        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.5, animations: { [weak self] in

            // self?.contentView.isHidden = false
            
            self?.contentViewBottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        })
    }

    @IBAction func dismissView(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.contentViewBottomConstraint.constant = strongSelf.contentView.frame.height
            strongSelf.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.presentingViewController?.dismiss(animated: false, completion: nil)
        }) 

    }
    
    @IBAction func onSignup(_ sender: UIButton) {
        guard let signupVC = storyboard?.instantiateViewController(identifier: "SignupViewController") as? SignupViewController else { return }
        signupVC.modalPresentationStyle = .overCurrentContext
        signupVC.parentVC = self
        signupVC.email = emailTextField.text
        signupVC.password = passwordTextField.text
        present(signupVC, animated: false)
    }
    
    @IBAction func onNativeSignin(_ sender: UIButton) {
        
    }
    
    @IBAction func onFacebookLogin() {

        userProvider.loginWithFaceBook(from: self, completion: { [weak self] result in

            switch result {

            case .success(let token):

                // self?.onSTYLiSHSignIn(token: token)
                self?.onWCSignIn(token: token)

            case .failure:

                LKProgressHUD.showSuccess(text: "Facebook 登入失敗!")
            }
        })
    }

    func onSTYLiSHSignIn(token: String) {

        LKProgressHUD.show()

        userProvider.signInToSTYLiSH(fbToken: token, completion: { [weak self] result in

            LKProgressHUD.dismiss()

            switch result {

            case .success:

                LKProgressHUD.showSuccess(text: "登入成功")

            case .failure:

                LKProgressHUD.showSuccess(text: "登入失敗!")
            }

            DispatchQueue.main.async {

                self?.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func onWCSignIn(token: String) {

        LKProgressHUD.show()

        userProvider.signInToWC(fbToken: token, completion: { [weak self] result in

            LKProgressHUD.dismiss()

            switch result {

            case .success:

                LKProgressHUD.showSuccess(text: "登入成功")

            case .failure:

                LKProgressHUD.showSuccess(text: "登入失敗!")
            }

            DispatchQueue.main.async {

                self?.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        })
    }

}
