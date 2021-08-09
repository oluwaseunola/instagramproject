//
//  CaptionViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class CaptionViewController: UIViewController, UITextViewDelegate {

    let image: UIImage?
    
    private let imageView : UIImageView = {
        let view = UIImageView()
        
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        
        
        return view
        
    }()
    
    private let textView : UITextView = {
        let view = UITextView()
        view.text = "Add caption..."
        
        view.backgroundColor = .secondarySystemBackground
        view.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        
        
        return view
    }()
    
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        textView.delegate = self
        view.addSubview(imageView)
        view.addSubview(textView)
        imageView.image = self.image
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPostButton))

        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size : CGFloat = view.width/4
        imageView.frame = CGRect(x: (view.width - size)/2, y: view.safeAreaInsets.top + 10, width: size, height: size)
        textView.frame = CGRect(x: 20, y: imageView.bottom + 20, width: view.width-40, height: 100)

    }
    
    
    @objc func didTapPostButton(){
        textView.resignFirstResponder()
        
        guard let newPostID = createNewPostID() else {return}
        
        let post = image?.pngData()
        
        guard let caption = textView.text else{return}
        
        guard let dateString = Date().makeDate(date: Date()) else {return}
        
        StorageManager.shared.uploadPost(post: post, postID: newPostID)  { downloadURL in
           
            
            guard let safeURL = downloadURL else{return}
            
                
                
            
            let postModel = Post(id: newPostID, caption: caption, date: dateString, likers: [], postDownloadURL: safeURL.absoluteString)
            
            DatabaseManager.shared.addUserPost(post: postModel) { [weak self] success in
                print("hi")
                guard success else{return print("failed to upload")}
                
                
                DispatchQueue.main.async {
                    self?.tabBarController?.selectedIndex = 0
                    self?.navigationController?.popToRootViewController(animated: true)
                    
                    
                }
                
                
                
            }
        }
            
            
        
    
        
    }
    
    private func createNewPostID()-> String?{
        let date = Date().timeIntervalSince1970
        let randomNumber = Int.random(in: 0...100)
        guard let username = UserDefaults.standard.string(forKey: "username") else{return nil}
        
        return "\(username)_\(randomNumber)_\(date)"
        
    }
    
//MARK: - Text view delegate functions
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add caption..." {
            textView.text = nil
        }
    
    }
    
    
   

}
