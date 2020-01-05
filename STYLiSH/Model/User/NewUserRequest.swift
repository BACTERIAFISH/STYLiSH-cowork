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

    case signin(String)

    case checkout(token: String, body: Data?)

    var headers: [String: String] {

        switch self {
            
        case .signup:

            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]

        case .signin:

            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]

        case .checkout(let token, _):

            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
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

        case .signin(let token):

            let dict = [
                "provider": "facebook",
                "access_token": token
            ]
            
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)

        case .checkout(_, let body):

            return body
        }
    }

    var method: String {

        switch self {

        case .signup, .signin, .checkout: return STHTTPMethod.POST.rawValue

        }
    }

    var endPoint: String {

        switch self {
            
        case .signup: return "/user/signup"

        case .signin: return "/user/signin"

        case .checkout: return "/order/checkout"
        }
    }

}
