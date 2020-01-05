//
//  UserManager.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import FBSDKLoginKit

typealias FacebookResponse = (Result<String>) -> Void

enum FacebookError: String, Error {

    case noToken = "讀取 Facebook 資料發生錯誤！"

    case userCancel

    case denineEmailPermission = "請允許存取 Facebook email！"
}

enum STYLiSHSignInError: Error {

    case noToken
}

class UserProvider {

    func signInToSTYLiSH(fbToken: String, completion: @escaping (Result<Void>) -> Void) {

        HTTPClient.shared.request(STUserRequest.signin(fbToken), completion: { result in

            switch result {

            case .success(let data):

                do {

                    let userObject = try JSONDecoder().decode(STSuccessParser<UserObject>.self, from: data)

                    KeyChainManager.shared.token = userObject.data.accessToken
                    
                    UserDataManager.shared.saveUser(user: userObject.data.user)
                    
                    completion(Result.success(()))

                } catch {

                    completion(Result.failure(error))
                }

            case .failure(let error):

                completion(Result.failure(error))
            }

        })
    }
    
    func signUpToWC(email: String, password: String, name: String, birthday: String, completion: @escaping (Result<Void>) -> Void) {

        NewHTTPClient.shared.request(WCUserRequest.signup(email: email, password: password, name: name, birthday: birthday), completion: { result in

            switch result {

            case .success(let data):

                do {

                    let userObject = try JSONDecoder().decode(STSuccessParser<UserObject>.self, from: data)

                    KeyChainManager.shared.token = userObject.data.accessToken
                    
                    UserDataManager.shared.saveUser(user: userObject.data.user)
                    
                    completion(Result.success(()))

                } catch {

                    completion(Result.failure(error))
                }

            case .failure(let error):

                completion(Result.failure(error))
            }

        })
    }
    
    func signInToWC(email: String, password: String, completion: @escaping (Result<Void>) -> Void) {

        NewHTTPClient.shared.request(WCUserRequest.signin(email: email, password: password), completion: { result in

            switch result {

            case .success(let data):

                do {

                    let userObject = try JSONDecoder().decode(STSuccessParser<UserObject>.self, from: data)

                    KeyChainManager.shared.token = userObject.data.accessToken
                    
                    UserDataManager.shared.saveUser(user: userObject.data.user)
                    
                    completion(Result.success(()))

                } catch {

                    completion(Result.failure(error))
                }

            case .failure(let error):

                completion(Result.failure(error))
            }

        })
    }
    
    func signInFBToWC(fbToken: String, completion: @escaping (Result<Void>) -> Void) {

        NewHTTPClient.shared.request(WCUserRequest.signinFB(fbToken), completion: { result in

            switch result {

            case .success(let data):

                do {

                    let userObject = try JSONDecoder().decode(STSuccessParser<UserObject>.self, from: data)

                    KeyChainManager.shared.token = userObject.data.accessToken
                    
                    UserDataManager.shared.saveUser(user: userObject.data.user)
                    
                    completion(Result.success(()))

                } catch {

                    completion(Result.failure(error))
                }

            case .failure(let error):

                completion(Result.failure(error))
            }

        })
    }

    func loginWithFaceBook(from: UIViewController, completion: @escaping FacebookResponse) {
        
        LoginManager().logIn(permissions: ["email", "user_birthday"], from: from, handler: { (result, error) in

            guard error == nil else { return completion(Result.failure(error!)) }

            guard let result = result else {

                let fbError = FacebookError.noToken

                LKProgressHUD.showFailure(text: fbError.rawValue)

                return completion(Result.failure(fbError))
            }

            switch result.isCancelled {

            case true: break

            case false:

                guard result.declinedPermissions.contains("email") == false, result.declinedPermissions.contains("user_birthday") == false else {

                    let fbError = FacebookError.denineEmailPermission

                    LKProgressHUD.showFailure(text: fbError.rawValue)

                    return completion(Result.failure(fbError))
                }

                guard let token = result.token?.tokenString else {

                    let fbError = FacebookError.noToken

                    LKProgressHUD.showFailure(text: fbError.rawValue)

                    return completion(Result.failure(fbError))
                }

                completion(Result.success(token))
            }

        })
    }

    func checkout(order: Order, prime: String, completion: @escaping (Result<Reciept>) -> Void) {

        guard let token = KeyChainManager.shared.token else {

            return completion(Result.failure(STYLiSHSignInError.noToken))
        }
        
        let body = CheckoutAPIBody(order: order, prime: prime)
        
        let request = STUserRequest.checkout(
            token: token,
            body: try? JSONEncoder().encode(body)
        )

        HTTPClient.shared.request(request, completion: { result in

            switch result {

            case .success(let data):

                do {

                    let reciept = try JSONDecoder().decode(STSuccessParser<Reciept>.self, from: data)

                    DispatchQueue.main.async {

                        completion(Result.success(reciept.data))
                    }

                } catch {

                    completion(Result.failure(error))
                }

            case .failure(let error):

                completion(Result.failure(error))
            }
        })
    }

    func getProfile(completion: @escaping (Result<Profile>) -> Void) {

        guard let token = KeyChainManager.shared.token else {

            return completion(Result.failure(STYLiSHSignInError.noToken))
        }
        
        let request = STUserRequest.getProfile(token)

        HTTPClient.shared.request(request, completion: { result in

            switch result {

            case .success(let data):

                do {

                    let profile = try JSONDecoder().decode(STSuccessParser<Profile>.self, from: data)

                    DispatchQueue.main.async {

                        completion(Result.success(profile.data))
                    }

                } catch {

                    completion(Result.failure(error))
                }

            case .failure(let error):

                completion(Result.failure(error))
            }
        })
    }
}
