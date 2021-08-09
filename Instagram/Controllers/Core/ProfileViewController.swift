//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class ProfileViewController: UIViewController {
    
   
    let user : User
    
    var currentUser : Bool {
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username") ?? "".lowercased()
    }
    
    //MARK: - Initializer
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.username
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(didTapSettings))
        
        barButton.tintColor = .white
        navigationItem.rightBarButtonItem = barButton
        
      
}
    
    

    
    private func configureNavBarButton(){
        
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(didTapSettings))
        
        
    }
    
    @objc func didTapSettings(){
        let settings = SettingsViewController()
        settings.title = "Settings"
        present(UINavigationController(rootViewController: settings), animated: true, completion: nil)
    }
    
}
