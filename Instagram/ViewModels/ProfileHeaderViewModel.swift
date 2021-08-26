//
//  File.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-09.
//

import Foundation

enum ProfileButtonState {
    case currentUser
    case visitor(isFollowing: Bool )
}

struct ProfileHeaderViewModel {
    
    let profilePicURL : URL?
    let followerCount : Int
    let followingCount: Int
    let postCount : Int
    let bio : String?
    let name: String?
    let buttonType: ProfileButtonState
    
    
    
    
}
