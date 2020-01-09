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
    
    let socket = WebSocket(url: URL(string: "ws://thewenchin.com:8080")!)
    
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
        print("deinit")
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    @IBAction func send(_ sender: UIButton) {
        guard let input = inputTextField.text, input != "" else { return }
        setRequest(action: .clientMessage, message: input)
        messages.append(SCWho.user.rawValue + input)
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
           formatter.dateFormat = "yyyy/MM/dd\nhh:mm:ss"
           return formatter.string(from: date)
       }
}

extension ClientServiceViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        setRequest(action: .clientInit)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        messages.append(SCWho.server.rawValue + "很抱歉伺服器掛掉了，一切都是後端的問題。")
        chatRenew()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        guard let data = text.data(using: .utf16) else { return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(SCResponse.self, from: data)
            messages = response.payload.messages
            //print(response)
            chatRenew()
        } catch {
            messages.append(SCWho.server.rawValue + "很抱歉伺服器掛掉了，一切都是後端的問題。")
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
        if messages[indexPath.row].contains(SCWho.server.rawValue) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatServerTableViewCell", for: indexPath) as? ChatServerTableViewCell else { return UITableViewCell() }
            
            let text = messages[indexPath.row].replacingOccurrences(of: SCWho.server.rawValue, with: "")
            
            cell.severLabel.text = text
            return cell
        } else if messages[indexPath.row].contains(SCWho.user.rawValue) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatClientTableViewCell", for: indexPath) as? ChatClientTableViewCell else { return UITableViewCell() }
            
            let text = messages[indexPath.row].replacingOccurrences(of: SCWho.user.rawValue, with: "")
            cell.clientLabel.text = text
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

extension ClientServiceViewController: UITableViewDelegate {
    
}

enum SCWho: String {
    case server = "server_bot==@%&"
    case user = "user==@%&"
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
    let updateTime: Int
}
