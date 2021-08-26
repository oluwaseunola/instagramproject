//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class NotificationsManager {

    static let shared = NotificationsManager()
    
    
    init() {
        
    }
    
    enum IGtype : Int{
        case like = 1
        case comment = 2
        case follow = 3
    }
    
    
    public func getNotifications(completion: @escaping (([IGNotificaton])-> Void)){
        DatabaseManager.shared.getNotifications(completion: completion)
    }

    
    public func createNotification (notification: IGNotificaton, for username: String){
        
        guard let dictionary = notification.makeDictionary() else {return}
        
        let id = notification.identifier
        
        DatabaseManager.shared.insertNotification(for: username, notification: dictionary, identifier: id) { success in
            
            
            
            
        }
        
        
        
        
    }
    
    static func setIdentifier()->String{
        
        let num1 = Int.random(in: 0...1000)
        let num2 = Int.random(in: 0...1000)
        let id = "\(num1)_\(num2)_\(Date().timeIntervalSince1970)"
        
        return id
    }
   

}
