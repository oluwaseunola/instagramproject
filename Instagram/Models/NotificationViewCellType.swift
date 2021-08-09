//
//  NotificationViewCellType.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-05.
//

import Foundation

enum NotificationCellType {
    
    case followNotification(viewModel: FollowNotificatoinViewModel)
    case likeNotification(viewModel: LikeNotificationViewModel)
    case commmentNotificatoin(viewModel: CommentNotificationViewModel)
    
    
}
