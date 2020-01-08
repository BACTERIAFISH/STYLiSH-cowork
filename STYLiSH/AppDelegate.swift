//
//  AppDelegate.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import AdSupport
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
        
        TPDSetup.setWithAppId(
            Bundle.STValueForInt32(key: STConstant.tapPayAppID),
            withAppKey: Bundle.STValueForString(key: STConstant.tapPayAppKey),
            with: TPDServerType.sandBox
        )

        TPDSetup.shareInstance().setupIDFA(
            ASIdentifierManager.shared().advertisingIdentifier.uuidString
        )

        TPDSetup.shareInstance().serverSync()
        
        GIDSignIn.sharedInstance().clientID = "413375994511-esf1u896jdk0qalhnicfpt0404sh28tl.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    @available(iOS 9.0, *)
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:])
    -> Bool {

       return ApplicationDelegate.shared.application(app, open: url, options: options) || GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        //let userId = user.userID                  // For client-side use only!
        guard let idToken = user.authentication.idToken else { return } // Safe to send to the server
        //let fullName = user.profile.name
        //let givenName = user.profile.givenName
        //let familyName = user.profile.familyName
        //let email = user.profile.email
        print("google sign in success")
        
        guard let authVC = GIDSignIn.sharedInstance()?.presentingViewController as? AuthViewController else { return }
        
        authVC.onWCSignInGoogle(token: idToken)
    }
}
