//
//  NotificationsViewModels.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-05.
//

import Foundation

struct FollowNotificatoinViewModel: Equatable{
    
    let profilePic : URL
    let username : String
    let followStatus : Bool
    let timeStamp : String
    
}

struct LikeNotificationViewModel: Equatable{
    
    let profilePic : URL
    let username : String
    let postURL : URL
    let timeStamp : String
    
    
    
}

struct CommentNotificationViewModel: Equatable{
    
    let profilePic : URL
    let username : String
    let postURL : URL
    let timeStamp : String
    
    
}
