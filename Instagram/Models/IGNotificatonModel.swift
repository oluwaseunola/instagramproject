//
//  IGNotificatonModel.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-06.
//

import Foundation


struct IGNotificaton: Codable {
    
    let username : String
    let notificationType : Int
    let profilePic : String
    let postURL : String?
    let postID : String?
    let isFollowing : Bool?
    let timeStamp: String
    var identifier: String
    
    
}

