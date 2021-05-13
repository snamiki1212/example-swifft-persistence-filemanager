//
//  ViewController.swift
//  ExamplePersistence
//
//  Created by shunnamiki on 2021/05/13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var users: [User] = {
            if let users = User.load() {
                return users
            } else {
                return []
            }
        }()
        
        users.append(User(name: "name(\(users.count)"))
        
        User.save(users: users)
        print(users)
    }
    
    


}


import Foundation
struct User: Codable {
    var name: String
    static var archivedUrl: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = dir.appendingPathComponent("users").appendingPathExtension("plist")
        return url
    }()
    
    static func save(users: [User]){
        let encoder = PropertyListEncoder()
        guard let encoded = try? encoder.encode(users) else { return print("ERROR")}
        do {
            try encoded.write(to: User.archivedUrl)
        } catch {
            print(error)
        }
    }
    
    static func load() -> [User]? {
        guard let encoded = try? Data(contentsOf: User.archivedUrl) else { return nil }
        
        let decoder = PropertyListDecoder()
        guard let decoded = try? decoder.decode([User].self, from: encoded) else { return nil}
        return decoded
    }
}
