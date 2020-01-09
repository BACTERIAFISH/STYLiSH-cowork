//
//  ClientServiceViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/8.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit
import Starscream

class ClientServiceViewController: STBaseViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var token = ""
    
    let socket = WebSocket(url: URL(string: "wss://thewenchin.com:8080")!)
    
    var messages = [String]()
    
    var messageTime = [Int]()
    
    var isInit = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 5
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        if let accessToken = UserDefaults.standard.string(forKey: "userTokenKey") {
            token = accessToken

            socket.delegate = self
            socket.connect()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    @IBAction func send(_ sender: UIButton) {
        guard let input = inputTextField.text, input != "" else { return }
        setRequest(action: .clientMessage, message: input)
        messages.append(SCWho.user.rawValue + input)
        let time = Int(Date().timeIntervalSince1970) * 1000
        messageTime.append(time)
        chatRenew()
        
        inputTextField.text = ""
    }
    
    func setRequest(action: SCRequestAction, message: String = "") {
        let auth = SCAuth(token: token)
        switch action {
        case .clientInit:
            let validate = SCValidate(action: action.rawValue, auth: auth)
            fetch(data: validate)
        case .clientMessage:
            let payload = SCRequestPayload(message: message)
            let request = SCRequest(action: action.rawValue, auth: auth, payload: payload)
            fetch(data: request)
        }
    }
    
    func fetch<T: Codable>(data: T) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(data)
            socket.write(data: data)
        } catch {
            print("fetch encode error: \(error)")
        }
    }
    
    func getResponse(text: String) {
        guard let data = text.data(using: .utf16) else { return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(SCResponse.self, from: data)
            messages = response.payload.messages
            messageTime = response.payload.updateTime
            chatRenew()
        } catch {
            print(error)
        }
    }
    
    func chatRenew() {
        chatTableView.reloadData()
        if isInit {
            chatTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: false)
            isInit = false
        } else {
            chatTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func transferDate(second: Int) -> String {
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(second/1000))
        formatter.dateFormat = "kk:mm"
        return formatter.string(from: date)
    }

}

extension ClientServiceViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        setRequest(action: .clientInit)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        messages.append(SCWho.serverBot.rawValue + "很抱歉伺服器掛掉了，一切都是後端的問題。")
        
        let time = Int(Date().timeIntervalSince1970) * 1000
        messageTime.append(time)
        chatRenew()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        guard let data = text.data(using: .utf16) else { return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(SCResponse.self, from: data)
            messages = response.payload.messages
            messageTime = response.payload.updateTime
            //print(response)
            chatRenew()
        } catch {
            messages.append(SCWho.serverBot.rawValue + "很抱歉伺服器掛掉了，一切都是後端的問題。")
            let time = Int(Date().timeIntervalSince1970) * 1000
            messageTime.append(time)
            chatRenew()
            print("websocket decode error: \(error)")
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("didReceiveData: \(socket)")
    }
    
}

extension ClientServiceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let time = transferDate(second: messageTime[indexPath.row])
        
        if message.contains(SCWho.serverBot.rawValue) || message.contains(SCWho.serverPerson.rawValue) {
            
            if message.contains(SCWho.image.rawValue) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatServerImageTableViewCell", for: indexPath) as? ChatServerImageTableViewCell else { return UITableViewCell() }

                let url = message.replacingOccurrences(of: SCWho.serverBot.rawValue, with: "")
                    .replacingOccurrences(of: SCWho.serverPerson.rawValue, with: "")
                    .replacingOccurrences(of: SCWho.image.rawValue, with: "")
                
                cell.serverImageView.kf.setImage(with: URL(string: url))
                cell.timeLabel.text = time
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatServerTableViewCell", for: indexPath) as? ChatServerTableViewCell else { return UITableViewCell() }
            
            let text = message.replacingOccurrences(of: SCWho.serverBot.rawValue, with: "")
                .replacingOccurrences(of: SCWho.serverPerson.rawValue, with: "")
            
            cell.severLabel.text = text
            cell.timeLabel.text = time
            return cell
            
        } else if message.contains(SCWho.user.rawValue) {
            
//            if message.contains(SCWho.image.rawValue) {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatClientImageTableViewCell", for: indexPath) as? ChatClientImageTableViewCell else { return UITableViewCell() }
//
//                cell.url = message.replacingOccurrences(of: SCWho.user.rawValue + SCWho.image.rawValue, with: "")
//                cell.timeLabel.text = time
//                return cell
//            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatClientTableViewCell", for: indexPath) as? ChatClientTableViewCell else { return UITableViewCell() }
            
            let text = message.replacingOccurrences(of: SCWho.user.rawValue, with: "")
    
            cell.clientLabel.text = text
            cell.timeLabel.text = time
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

extension ClientServiceViewController: UITableViewDelegate {
    
}

enum SCWho: String {
    case serverBot = "server_bot==@%&"
    case serverPerson = "server_person==@%&"
    case user = "user==@%&"
    case image = "@@@@"
}

enum SCRequestAction: String {
    case clientInit = "client-init"
    case clientMessage = "client-message"
}

struct SCValidate: Codable {
    let action: String
    let auth: SCAuth
}

struct SCRequest: Codable {
    let action: String
    let auth: SCAuth
    let payload: SCRequestPayload
}

struct SCRequestPayload: Codable {
    let message: String
}

struct SCAuth: Codable {
    let token: String
}

struct SCResponse: Codable {
    let action: String
    let payload: SCResponsePayload
}

struct SCResponsePayload: Codable {
    let id: Int
    let messages: [String]
    let auto: Bool
    let updateTime: [Int]
}