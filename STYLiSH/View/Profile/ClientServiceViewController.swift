//
//  ClientServiceViewController.swift
//  STYLiSH
//
//  Created by FISH on 2020/1/8.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit
import Starscream

class ClientServiceViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    let socket = WebSocket(url: URL(string: "ws://thewenchin.com:8080")!)

    override func viewDidLoad() {
        super.viewDidLoad()

        socket.delegate = self
        socket.connect()
        
    }
    
    @IBAction func send(_ sender: UIButton) {
        guard let input = inputTextField.text, input != "" else { return }
        socket.write(string: input)
    }
    
}

extension ClientServiceViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("didConnect: \(socket)")
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("didDisconnect: \(socket)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("didReceiveMessage: \(socket)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("didReceiveData: \(socket)")
    }
    
}
