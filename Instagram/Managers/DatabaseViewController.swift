import UIKit
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init(){}
    
    let database = Firestore.firestore()
    
    public func findUser(with email: String, completion: @escaping (User?)-> Void){
        let ref = database.collection("users")
        ref.getDocuments() { snapshot, error in
            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}), error == nil else {return}
            
            let user = users.first(where: {$0.email == email })
            
            completion(user)
            
        }
    }
    
    public func findUsername(with username: String, completion: @escaping (User?)-> Void){
        let ref = database.collection("users")
        ref.getDocuments() { snapshot, error in
            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}), error == nil else {return}
            
            let user = users.first(where: {$0.username == username })
            
            completion(user)
            
        }
    }

    public func createUser (newUser: User, completion: @escaping (Bool)->Void){
        
        let referencee = database.document("users/\(newUser.username)")
        guard let userData = newUser.makeDictionary() else{return}
        referencee.setData(userData){error in
            
            completion(error == nil)
            
        }
        
    }
    
    public func addUserPost (post: Post, completion: @escaping (Bool)->Void){
        
        guard let user = UserDefaults.standard.string(forKey: "username") else{return}
        
        
        let referencee = database.document("users/\(user)/userPosts/\(post.id)")
        guard let userData = post.makeDictionary() else{return}
        
        referencee.setData(userData){error in
            
            completion(error == nil)
            
        }
        
    }

    
    public func retrievePost(for user: String, completion: @escaping ((Result<[Post],Error>)-> Void)){
        
        let ref = database.collection("users").document(user).collection("userPosts")
        
        ref.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            
            let userPosts = documents.compactMap { Post(with: $0.data())}
            
            completion(.success(userPosts))
            
            
        }
        
        
        
    }
    
    public func queryUsers(with username: String, completion: @escaping (([User])-> Void)){
        
        let ref = database.collection("users")
        
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}) else {return}
    
        
            let filteredUsers = users.filter({ $0.username.lowercased().hasPrefix(username.lowercased())
            })
            
            completion(filteredUsers)
        }
        
        
    }
    
    public func explorePosts(completion: @escaping (([Post])-> Void)){
        var userPosts = [Post]()
        let ref = database.collection("users")
        ref.getDocuments() { [weak self] snapshot, error in
            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}), error == nil else {return}
            
            let group = DispatchGroup()
            
            users.forEach { user in
                
                let postRef = self?.database.collection("users/\(user.username)/userPosts")
                group.enter()
                postRef?.getDocuments(completion: { snapshot, _ in
                   
                    guard let posts = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else {return}
                    
                    defer{
                        group.leave()
                    }
                    
                    userPosts.append(contentsOf: posts)
                    

                })
                
            }
            
            group.notify(queue: .main) {
                completion(userPosts)
            }
            
            
        }
        
        
        
        
        
    
}
    
    static func setIdentifier()->String{
        
        let num1 = Int.random(in: 0...1000)
        let num2 = Int.random(in: 0...1000)
        let id = "\(num1)_\(num2)_\(Date().timeIntervalSince1970)"
        
        return id
    }
    
    public func getNotifications(completion: @escaping (([IGNotificaton])->Void)){
        
        guard let username = UserDefaults.standard.string(forKey: "username") else{return}
        
        let ref = database.collection("users").document(username).collection("notifications")
        
        ref.getDocuments { snapshot, error in
            
            guard let notifications = snapshot?.documents.compactMap({ IGNotificaton(with: $0.data())}) else{return}
            
            completion(notifications)
            
        }
    }
    
    
    public func insertNotification(for username: String, notification: [String:Any], identifier: String, completion: @escaping ((Bool)->Void)){
    

        let ref = database.collection("users").document(username).collection("notifications").document(identifier)
        
        ref.setData(notification)

        
        
    }
    
    public func aquirePostID(username: String, post identifier: String, completion: @escaping ((Post?)->Void)){
        
        let ref = database.collection("users").document(username).collection("userPosts").document(identifier)
        
        ref.getDocument { snapshot, error in
            
            guard let data = snapshot?.data() else {
                completion(nil)
                return}
            let post = Post(with: data)
            
            completion(post)
            
            
            
            
        }
    }
    
    enum RelationshipState {
        case follow
        case unfollow
    }
    
    
    public func updateRelationship(state: RelationshipState, for username: String, completion: @escaping (Bool)-> Void){
        guard let currentUser = UserDefaults.standard.string(forKey: username) else {return}

        let currentUserFollowing = database.collection("users").document(currentUser).collection("following")
        
        let targetFollowers = database.collection("users").document(username).collection("followers")

        switch state{
        case.unfollow:
            currentUserFollowing.document(username).delete()
            targetFollowers.document(currentUser).delete()
            
            completion(true)
            
        case.follow:
            currentUserFollowing.addDocument(data: ["following" : username])
            targetFollowers.addDocument(data: ["follower" : currentUser])
            
            completion(true)
        
        }
        
        
    }
    
}
