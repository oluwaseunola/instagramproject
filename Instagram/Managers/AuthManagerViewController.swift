//
//  AuthManagerViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit
import FirebaseAuth

class AuthManager {

    
    static let shared = AuthManager()
    
    private init(){}
    
    let auth = Auth.auth()

    
    public var isSignedIn : Bool {
        return auth.currentUser != nil
    }
    
    public func signIn(email: String?, password: String, username: String?, completion: @escaping (Result<User, Error>)->Void ){
        
        guard let email = email else {
            return
        }
        
        DatabaseManager.shared.findUser(with: email) {[weak self] user in
            guard let user = user else {
                print("failed")
                return
            }
            
            self?.auth.signIn(withEmail: email, password: password) { result, error in
                guard let error = error else{return}
                
                guard  result != nil else{
                    print("no results")
                    completion(.failure(error))
                    return}
            }
            
            UserDefaults.standard.set(user.username, forKey: "username")
            UserDefaults.standard.set(user.email, forKey: "email")
            completion(.success(user))

        }
        
        
    }
    
    public func registerNewUser(email: String, password: String, username: String, profilePic: Data?, completion: @escaping (Result<User, Error>)->Void){
        
        let user = User(username: username, email: email)
         
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else{return}
            
            DatabaseManager.shared.createUser(newUser: user){ success in
                
                if success{
                    print("hi")
                    StorageManager.shared.uploadProfilePicture(username: username, picture: profilePic) { uploaded in
                        if uploaded{
                            
                            completion(.success(user))
                        }
                        else{
                            completion(.failure(error!))
                        }
                    }
                    
                }
                else{print("something is wrong")}
                
                
                
            }
        }
        
    }
    
    public func logOutUser(completion: ((Bool)->Void)){
        do{
            try Auth.auth().signOut()
            completion(true)
            return
        }catch{
            print(error.localizedDescription)
            completion(false)
            return
        }
    }
    
}
