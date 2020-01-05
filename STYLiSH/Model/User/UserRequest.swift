//
//  UserRequest.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

enum STUserRequest: STRequest {

    case signin(String)

    case checkout(token: String, body: Data?)
    
    case getProfile(String)

    var headers: [String: String] {

        switch self {

        case .signin:

            return [STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue]

        case .checkout(let token, _):

            return [
                STHTTPHeaderField.auth.rawValue: "Bearer \(token)",
                STHTTPHeaderField.contentType.rawValue: STHTTPHeaderValue.json.rawValue
            ]
        case .getProfile(let token):
            
            return [STHTTPHeaderField.auth.rawValue: "Bearer \(token)"]
            
        }
        
    }

    var body: Data? {

        switch self {

        case .signin(let token):

            let dict = [
                "provider": "facebook",
                "access_token": token
            ]
            
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)

        case .checkout(_, let body):

            return body
            
        case .getProfile:
            
            return nil
            
        }
    }

    var method: String {

        switch self {

        case .signin, .checkout: return STHTTPMethod.POST.rawValue
            
        case .getProfile: return STHTTPMethod.GET.rawValue

        }
    }

    var endPoint: String {

        switch self {

        case .signin: return "/user/signin"

        case .checkout: return "/order/checkout"
            
        case .getProfile: return "/user/profile"
            
        }
    }

}
