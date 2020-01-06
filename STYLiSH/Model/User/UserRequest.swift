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
    
    case ongoingOrder(String)
    
    case getOrder(String)

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
            
        case .ongoingOrder(let token):
            
            return [STHTTPHeaderField.auth.rawValue: "Bearer \(token)"]
            
        case .getOrder(let token):
            
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
            
        case .getProfile, .ongoingOrder, .getOrder:
            
            return nil
            
        }
    }

    var method: String {

        switch self {

        case .signin, .checkout: return STHTTPMethod.POST.rawValue
            
        case .getProfile, .ongoingOrder, .getOrder: return STHTTPMethod.GET.rawValue

        }
    }

    var endPoint: String {

        switch self {

        case .signin: return "/user/signin"

        case .checkout: return "/order/checkout"
            
        case .getProfile: return "/user/profile"
            
        case .ongoingOrder: return "/user/ongoing_order"
            
        case .getOrder: return "/user/order"
            
        }
    }

}
