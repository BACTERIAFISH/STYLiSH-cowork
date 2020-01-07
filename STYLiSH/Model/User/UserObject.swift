//
//  UserObject.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

struct UserObject: Codable {

    let accessToken: String

    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}

struct User: Codable {

    let id: Int

    let provider: String

    let name: String

    let email: String

    let picture: String?
}

struct Reciept: Codable {

    let number: String
}

struct Profile: Codable {
    
    let id: Int

    let provider: String

    let name: String

    let email: String

    let picture: String?
    
    let birthday: String?
    
    let points: Int
}

//struct WCOrderData: Codable {
//    let data: [WCOrderNotYet]
//}

struct WCOrderNotYet: Codable {
    
    let id: Int
    
    let number: String
    
    let time: Int
    
    let status: Int
    
    let details: String
    
    let userId: Int
    
    let logistics: String
    
    let points: Int
    
    let pointsUsed: Int
}

struct WCOrder: Codable {
    
    let id: Int
    
    let number: String
    
    let time: Int
    
    let status: Int
    
    let details: WCOrderDetails
    
    let userId: Int
    
    let logistics: String
    
    let points: Int
    
    let pointsUsed: Int
}

struct WCOrderDetails: Codable {
    
    let list: [OrderListObject]
    
    let total: Int
    
    let freight: Int
    
    let payment: String
    
    let shipping: String
    
    let subtotal: Int
    
    let recipient: WCOrderRecipient
}

struct WCOrderRecipient: Codable {
    
    let name: String
    
    let time: String
    
    let email: String
    
    let phone: String
    
    let address: String
}
