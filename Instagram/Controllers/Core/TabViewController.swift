//
//  TabViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class TabViewController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .label
        
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notifications = NotificationsViewController()
        
//        guard let username = UserDefaults.standard.string(forKey: "username") else{return}
//
//        guard let email = UserDefaults.standard.string(forKey: "email") else{return}
//
        
        UserDefaults.standard.set("SeunOlalekan", forKey: "username")
        guard let username = UserDefaults.standard.string(forKey: "username") else{return}
        
        let currentUser = User(username: username, email: "email" )
        
        let profile = ProfileViewController(user: currentUser)
        
        
        
        
        home.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold) ), selectedImage: UIImage(systemName: "house.fill"))
        
        explore.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), selectedImage: UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold) ))
        
        camera.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.app", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), selectedImage: UIImage(systemName: "plus.app.fill"))
        
        notifications.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), selectedImage: UIImage(systemName: "heart.fill"))
        
    
        profile.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), selectedImage: UIImage(systemName: "person.fill"))
        
        
        let nav1  = UINavigationController(rootViewController: home)
        let nav2  = UINavigationController(rootViewController: explore)
        let nav3  = UINavigationController(rootViewController: camera)
        let nav4  = UINavigationController(rootViewController: notifications)
        let nav5  = UINavigationController(rootViewController: profile)

        
        
        let controllers = [nav1, nav2, nav3, nav4, nav5]
        
        self.setViewControllers(controllers, animated: false)
                
    }
    
    
    

}
