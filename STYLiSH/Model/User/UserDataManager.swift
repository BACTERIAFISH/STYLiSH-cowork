//
//  UserDataManager.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/3.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import Foundation

class UserDataManager {
    
    static let shared = UserDataManager()
    
    private init() {}
    
    private let userKey = "userKey"
    
    private let userTokenKey = "userTokenKey"
    
    func saveUser(user: User, token: String) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: userKey)
        UserDefaults.standard.set(token, forKey: userTokenKey)
        NotificationCenter.default.post(name: NSNotification.Name("saveUser"), object: self)
    }
    
    func loadUser(completion: ((User) -> Void)) {
        guard
            let data = UserDefaults.standard.object(forKey: userKey) as? Data,
            let user = try? PropertyListDecoder().decode(User.self, from: data)
        else { return }
        completion(user)
    }
    
    func removeUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: userTokenKey)
    }
}
