//
//  PostViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import Foundation

struct Post:Codable {
    
    let id : String
    
    let caption : String
    
    let date : String
    
    let likers : [String]
    
    let postDownloadURL : String
    
    var reference : String? {
        guard let user = UserDefaults.standard.string(forKey: "username")else {return nil}
        return "\(user)/userpost/\(id).png"
    }
    
    
}
