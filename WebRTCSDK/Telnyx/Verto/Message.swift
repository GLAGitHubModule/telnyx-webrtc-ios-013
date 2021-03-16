//
//  Message.swift
//  WebRTCSDK
//
//  Created by Guillermo Battistel on 03/03/2021.
//

import Foundation

private let PROTOCOL_VERSION: String = "2.0"

class Message {
    private var jsonMessage: [String: Any] = [String: Any]()

    let jsonrpc = PROTOCOL_VERSION
    var id: String = UUID.init().uuidString.lowercased()
    var method: Method?
    var params: [String: Any]?
    var result: [String: Any]?
    var serverError: [String: Any]?
    
    init() {}
    
    init(_ params: [String: Any], method: Method) {
        self.method = method

        self.jsonMessage = [String: Any]()
        self.jsonMessage["jsonrpc"] = self.jsonrpc
        self.jsonMessage["id"] = self.id
        self.jsonMessage["method"] = self.method?.rawValue
        self.jsonMessage["params"] = params

    }
    
    func encode() -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonMessage, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("Message:: encode() error")
            return nil
        }
        print("Message:: encode() " + jsonString)
        return jsonString
    }
    
    
    func decode(message: String) -> Message? {
        guard let data = message.data(using: .utf8) else { return nil }
        guard let jsonMessage =  try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]  else { return nil }

        self.id = jsonMessage["id"] as? String ?? ""
        self.method = Method(rawValue: jsonMessage["method"] as? String ?? "")
        self.result = jsonMessage["result"] as? [String: Any]
        self.params = jsonMessage["params"] as? [String: Any]
        self.serverError = jsonMessage["error"] as? [String: Any]
        self.jsonMessage = jsonMessage

        print("Message:: decode() \(self.jsonMessage)")
        return self
    }
}
