//
//  AppDelegate.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import AdSupport
import IQKeyboardManager
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

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

        IQKeyboardManager.shared().isEnabled = true

        IQKeyboardManager.shared().shouldResignOnTouchOutside = true

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:])
    -> Bool {

        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
}
