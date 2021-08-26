//
//  ProfileHeaderCountView.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-10.
//

import UIKit

protocol ProfileHeaderCountViewDelegate : AnyObject {
    
    func didTapPosts()
    func didTapFollowers()
    func didTapFollowing()
    
}


class ProfileHeaderCountView: UIView {

    
    
    weak var delegate : ProfileHeaderCountViewDelegate?
    
    private let postsButton : UIButton = {
        let view = UIButton()
        view.setTitle("0\nPosts", for: .normal)
        view.setTitleColor(.label, for: .normal)
        view.titleLabel?.numberOfLines = 2
        view.layer.cornerRadius = 5
        view.titleLabel?.textAlignment = .center
        return view
    }()
    
    private let followersButton : UIButton = {
        let view = UIButton()
        
        view.setTitle("0\nFollowers", for: .normal)
        view.setTitleColor(.label, for: .normal)
        view.titleLabel?.numberOfLines = 2
        view.layer.cornerRadius = 5
        view.titleLabel?.textAlignment = .center
        
        

        return view
    }()
    
    private let followingButton : UIButton = {
        let view = UIButton()

        view.setTitle("0\nFollowing", for: .normal)
        view.setTitleColor(.label, for: .normal)
        view.titleLabel?.numberOfLines = 2
        view.layer.cornerRadius = 5
        view.titleLabel?.textAlignment = .center
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(followersButton)
        addSubview(postsButton)
        addSubview(followingButton)
        
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        postsButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)


        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth : CGFloat = (width-10)/3
        
        postsButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: height/2)
        
        followersButton.frame = CGRect(x: postsButton.right + 4, y: 0, width: buttonWidth, height: height/2)
        
        followingButton.frame = CGRect(x: followersButton.right + 4, y: 0, width: buttonWidth, height: height/2)
        
        
        
    }
    
    public func configure(with model: HeaderCountViewModel){
        
        postsButton.setTitle("\(model.postCount)\nPosts", for: .normal)
        followersButton.setTitle("\(model.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(model.followingCount)\nFollowing", for: .normal)


        
        
        
    }
    
    
    //MARK: - OBJC Functions
    
    @objc func didTapFollowersButton(){
        delegate?.didTapFollowers()
    }
    
    @objc func didTapPostsButton(){
        delegate?.didTapPosts()
    }
    
    @objc func didTapFollowingButton(){
        delegate?.didTapFollowing()
    }
    

    
    
    
    
    
    
}
