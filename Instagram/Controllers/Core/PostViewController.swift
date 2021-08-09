//
//  PostViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-31.
//

import UIKit

class PostViewController: UIViewController {

    let post : Post?
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Post"
        
    }
    

    
}
