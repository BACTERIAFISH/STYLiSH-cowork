//
//  NewUserRequest.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/4.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import Foundation

enum WCUserRequest: WCRequest {
    
    case signup(email: String, password: String, name: String, birthday: String)

    case signin(email: String, password: String)
    
    case signinFB(String)
    
    case signinGoogle(String)

    var headers: [String: String] {

        switch self {
            
        case .signup:

            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]

        case .signin, .signinFB, .signinGoogle:

            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]
        }
    }

    var body: Data? {

        switch self {
            
        case .signup(let email, let password, let name, let birthday):

        let dict = [
            "provider": "native",
            "email": email,
            "password": password,
            "name": name,
            "birthday": birthday
        ]
        
        return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
        case .signin(let email, let password):
            
            let dict = [
                "provider": "native",
                "email": email,
                "password": password
            ]
            
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)

        case .signinFB(let token):

            let dict = [
                "provider": "facebook",
                "access_token": token
            ]
            
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
        case .signinGoogle(let token):
            
            let dict = [
                "provider": "google",
                "access_token": token
            ]
            
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }
    }

    var method: String {

        switch self {

        case .signup, .signin, .signinFB, .signinGoogle: return STHTTPMethod.POST.rawValue

        }
    }

    var endPoint: String {

        switch self {
            
        case .signup: return "/user/signup"

        case .signin, .signinFB, .signinGoogle: return "/user/signin"

        }
    }

}
