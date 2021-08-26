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
            
            let userPosts = documents.compactMap { Post(with: $0.data())}.sorted(by: {$0.date < $1.date})
            
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
    
    public func explorePosts(completion: @escaping (([(post: Post, user:User)])-> Void)){
        var userPosts = [(post: Post, user: User)]()
        let ref = database.collection("users")
        ref.getDocuments() { [weak self] snapshot, error in
            guard let users = snapshot?.documents.compactMap({User(with: $0.data())}), error == nil else {return}
            
            let group = DispatchGroup()
            
            users.forEach { foundUser in
                
                let postRef = self?.database.collection("users/\(foundUser.username)/userPosts")
                group.enter()
                postRef?.getDocuments(completion: { snapshot, _ in
                   
                    guard let posts = snapshot?.documents.compactMap({Post(with: $0.data())}), error == nil else {return}
                    
                    defer{
                        group.leave()
                    }
                    
                    userPosts.append(contentsOf: posts.compactMap({(post: $0, user: foundUser)}))

                })
                
            }
            
            
            
            group.notify(queue: .main) {
                
                
                completion(userPosts)
            }
            
            
        }
        
        
        
        
        
    
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
        guard let currentUser = UserDefaults.standard.string(forKey: "username") else {return}

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
    
    public func fetchFollowerCount(with username: String, completion: @escaping (((follower: Int, following: Int, post: Int))-> Void) ){

        let refFollowers = database.collection("users").document(username).collection("followers")
        let refPosts = database.collection("users").document(username).collection("userPosts")
        let refFollowing = database.collection("users").document(username).collection("following")
        
        var followingCount = 0
        var postsCount = 0
        var followerCount = 0
        
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        group.enter()

        
        refFollowing.getDocuments { following, error in
            defer{group.leave()}
            guard let numberOfFollowing = following?.documents.count else {return}
            
            
            followingCount = numberOfFollowing
            
            
        }
        
        refFollowers.getDocuments { followers, error in
            defer{group.leave()}
            guard let numberOfFollowers = followers?.documents.count else {return}
            
            followerCount = numberOfFollowers
            
        }
        
        refPosts.getDocuments { posts, error in
            defer{group.leave()}
            guard let numberOfPosts = posts?.documents.count else {return}
            
            postsCount = numberOfPosts
            
        }
        
        group.notify(queue: .global()) {
            
            let results = (follower: followerCount, following: followingCount, post: postsCount)
            
            completion(results)
            
        }
        
    }
    
    public func isFollowing(targetuser: String, completion: @escaping (Bool)-> Void){
        guard let currentUser = UserDefaults.standard.string(forKey: "username") else {completion(false)
            return}
        
        let ref = database.collection("users").document(targetuser).collection("followers").document(currentUser)
        
        ref.getDocument { _, error in
            if error == nil{
                completion(true)
            } else{
                completion(false)
            }
        }
        
        
    }
    
    public func following(username: String, completion: @escaping ([User])-> Void){
       
        let ref = database.collection("users").document(username).collection("following")
        
        ref.getDocuments { users, error in
         let usernames = [User]()
            
            if error == nil{
                guard let userFollowing = users?.documents.compactMap({User(with: $0.data())}) else{return}
                
                completion(userFollowing)
            } else{
                print(error)
            }
        }
        
        
    }
    //MARK: - set & get info for user
    
    public func setInfo( info: UserInfo, completion: @escaping (Bool)->Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        let ref = database.collection("users").document(username).collection("userInfo").document("profileInfo")
        guard let info = info.makeDictionary() else{return}
       
        ref.setData(info) { error in
            if error == nil{
                completion(true)
            }
        }
        
    }
    
    public func getInfo(for username: String, completion: @escaping (UserInfo?)-> Void){
        
        let ref = database.collection("users").document(username).collection("userInfo").document("profileInfo")
        
        ref.getDocument { info, error in
            guard let info = info?.data(), let userInfo = UserInfo(with: info) else{return completion(nil)}
        
    
            completion(userInfo)
            
            
        }
        
        
    }
    
    
    public func addComments( postID: String, comment: CommentsModel, commentedUser: String, Completion: @escaping (Bool)-> Void){
        
        
        let identifier = "\(postID)_\(comment.username)_\(Date().timeIntervalSince1970)_\(Int.random(in: 0...1000))"
        
        let ref = database.collection("users").document(commentedUser).collection("userPosts").document(postID).collection("comments").document(identifier)
        
        ref.setData(comment.makeDictionary() ?? [:]) { error in
            
                Completion(error==nil)
            
        }
        
        
        
    }
    
    
    public func getComments(for postID: String, user: String, Completion: @escaping ([CommentsModel])-> Void){
        
        let ref = database.collection("users").document(user).collection("userPosts").document(postID).collection("comments")
        
        ref.getDocuments { comments, error in
        
            guard let comments = comments else{return}
            
            let model = comments.documents.compactMap({CommentsModel(with: $0.data())})
            
            if error == nil{
                Completion(model)
            }
            else{Completion([])}
        
        
            
        }
        
        
    }
    
    public func like (postID: String, owner: String , completion:@escaping (Bool)->Void ){
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        
        let ref = database.collection("users").document(owner).collection("userPosts").document(postID)
        
        aquirePostID(username: owner, post: postID) { post in
            
            guard var post = post else {
                return
            }

            
            if !post.likers.contains(username){
                
                post.likers.append(username)
                
                guard let data = post.makeDictionary() else {return}
                
                ref.setData(data) { error in
                    if error == nil {
                        completion(true)
                    }
                }
            }
            else{return}
            
           
            
        }
        
        
    }
    
    public func unlike (postID: String, owner: String , completion:@escaping (Bool)->Void ){
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        
        let ref = database.collection("users").document(owner).collection("userPosts").document(postID)
        
        aquirePostID(username: owner, post: postID) { post in
            
            guard var post = post else {
                return
            }
            
            
            post.likers.removeAll(where: {$0 == username})
            
            guard let data = post.makeDictionary() else {return}
            
            ref.setData(data) { error in
                if error == nil {
                    completion(true)
                }
            }
            
        }
        
        
    }
    
    

    
}
