import UIKit
import FirebaseStorage

class StorageManager {

    
    static let shared = StorageManager()
    
    private init(){}
    
    private let storage = Storage.storage()
    
    public func downloadPostURL(post: Post, completion: @escaping ((URL?)->Void) ){
        
        guard let ref = post.reference else {return}
        
        
        storage.reference().child(ref).downloadURL { url, _ in
            
            
            completion(url)
        }
        
        
    }
    
    public func downloadPicURL(for user: String, completion: @escaping ((URL?)->Void) ){
        
    
        let ref = "\(user)/profile_picture.png"
        
        
        storage.reference().child(ref).downloadURL { url, _ in
            
            
            completion(url)
        }
        
        
    }
    
    public func uploadProfilePicture(username: String, picture: Data?, completion: @escaping (Bool)->Void){
        
        guard let picture = picture else {
            return
        }

        
        storage.reference().child("\(username)/profile_picture.png").putData(picture, metadata: nil) { _, error in
           completion(error == nil)
        }
    }
    
    public func uploadPost(post: Data? , postID: String, completion: @escaping ((URL?)->Void)) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        guard let post = post else {
            return
        }
        
        let ref = storage.reference().child("\(username)/userpost/\(postID).png")

        
        ref.putData(post, metadata: nil) { _, error in
          
            ref.downloadURL { url, _ in
                guard let url = url else {
                    return
                }
                completion(url)
            }
            
           
        }
    }

}

