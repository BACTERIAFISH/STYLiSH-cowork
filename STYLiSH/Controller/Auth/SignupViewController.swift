//
//  SignupViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/4.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit
import JGProgressHUD

class SignupViewController: STBaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var checkPasswordTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    
    let userProvider = UserProvider()
    
    var parentVC: AuthViewController!
    
    var email: String?
    
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 12

        contentViewBottomConstraint.constant = contentView.frame.height
        
        emailTextField.text = email
        passwordTextField.text = password
        
        view.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.contentViewBottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        })
    }

    @IBAction func close(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.contentViewBottomConstraint.constant = strongSelf.contentView.frame.height
            strongSelf.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        })
    }
    
    @IBAction func onSignup(_ sender: UIButton) {
        onWCSignUp()
    }
    
    func onWCSignUp() {
        
        guard
            let email = emailTextField.text,
            validateEmail(email: email),
            let password = passwordTextField.text,
            password != "",
            let checkPassword = checkPasswordTextField.text,
            password == checkPassword,
            let name = nameTextField.text,
            name != "",
            let birthday = birthdayTextField.text,
            validateBirthday(birthday: birthday)
        else {
            print("signup data check error")
            return
        }

        let hud = JGProgressHUD(style: .dark)
        hud.show(in: parentVC.view)
        
        userProvider.signUpToWC(email: email, password: password, name: name, birthday: birthday) { [weak self] result in

            // guard let strongSelf = self else { return }

            switch result {

            case .success:
                DispatchQueue.main.async {
                    hud.textLabel.text = "註冊成功!"
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.dismiss(afterDelay: 1)
                }

            case .failure:
                DispatchQueue.main.async {
                    hud.textLabel.text = "註冊失敗!"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.dismiss(afterDelay: 1)
                }
            }

            DispatchQueue.main.async {
                // self?.backToRoot()
                self?.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func validateEmail(email: String) -> Bool {
      let range = NSRange(location: 0, length: email.utf16.count)
      var regex: NSRegularExpression?
      do {
        let pattern = #"^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$"#
        regex = try NSRegularExpression(pattern: pattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines, .dotMatchesLineSeparators])
        
      } catch {
        print("regex error: \(error)")
      }
      return regex?.firstMatch(in: email, options: [], range: range) != nil
    }
    
    private func validateBirthday(birthday: String) -> Bool {
      let range = NSRange(location: 0, length: birthday.utf16.count)
      var regex: NSRegularExpression?
      do {
        let pattern = #"\d{8}"#
        regex = try NSRegularExpression(pattern: pattern, options: [.allowCommentsAndWhitespace, .anchorsMatchLines, .dotMatchesLineSeparators])
        
      } catch {
        print("regex error: \(error)")
      }
      return regex?.firstMatch(in: birthday, options: [], range: range) != nil
    }
}
