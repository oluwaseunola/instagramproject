//
//  HeaderCollectionReusableView.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-09.
//

import SDWebImage
import UIKit

protocol HeaderCollectionReusableViewDelegate : AnyObject {
    func didTapFollow()
    func didTapUnfollow()
    func didTapEdit()
    func didTapProfilePic()
}


class HeaderCollectionReusableView: UICollectionReusableView {
       static let identifier = "HeaderCollectionReusableView"
    
    weak var delegate: HeaderCollectionReusableViewDelegate?
    
    
    private let profilePic : UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    public let countContainerView = ProfileHeaderCountView()
    
    
    
    private let bio : UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 16)
        view.text = "Hey welcome to my bio!"
        view.textColor = .secondaryLabel
        
        
        
        return view
    }()
    
    private let usernameLabel : UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .semibold)
        view.text = "Seun Olalekan"
        
        return view
    }()
    
    private let followButton : UIButton = {
        let button = UIButton()
        
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(countContainerView)
        addSubview(profilePic)
        addSubview(followButton)
        addSubview(bio)
        addSubview(usernameLabel)
        
        followButton.addTarget(self, action: #selector(didTapFollowEdit), for: .touchUpInside)
            
        profilePic.backgroundColor = .gray
        
        profilePic.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        
        profilePic.addGestureRecognizer(gesture)
            
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profilePic.image = nil
        usernameLabel.text = nil
        
        
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize : CGFloat = width/4
        profilePic.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        profilePic.layer.cornerRadius = imageSize/2
        
        countContainerView.frame = CGRect(x: profilePic.right + 5, y: 6, width: width - profilePic.width - 10, height: imageSize)
        
        usernameLabel.frame = CGRect(x: 5, y: profilePic.bottom + 10, width: width/2, height: 20)
        
        
        
        followButton.frame = CGRect(x: 5, y: height - 50, width: imageSize, height: 40)
        
        bio.frame = CGRect(x: 5, y: usernameLabel.bottom, width: width/2, height: height/3)
    }
    
    public func configureFollowButton(with model: HeaderCountViewModel){
        
        switch model.profileButtonType {
        case.currentUser:
            
            followButton.setTitle("Edit Profile", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.layer.borderWidth = 0.5
            followButton.layer.borderColor = UIColor.label.cgColor
            
            break
        case.visitor(let isFollowing):
            
            followButton.backgroundColor = isFollowing ? .none : .systemBlue
            followButton.layer.borderWidth = isFollowing ? 0.5 : 0
            followButton.layer.borderColor = isFollowing ? UIColor.label.cgColor : .none
            followButton.setTitle(isFollowing ? "Following" : "Follow", for: .normal)
            
            break
        }
        
    }
    
    public func configure(with model: ProfileHeaderViewModel){
        
        profilePic.sd_setImage(with: model.profilePicURL, completed: nil)
        
        bio.text = model.bio
        usernameLabel.text = model.name
        
        let containerViewModel = HeaderCountViewModel(postCount: model.postCount, followerCount: model.followerCount, followingCount: model.followingCount, profileButtonType: model.buttonType)
        
        countContainerView.configure(with: containerViewModel)
        
    }
    
    @objc func didTapFollowEdit(){
        print("hey")
        
        delegate?.didTapEdit()
        
    }
    
    @objc func didTapProfilePic(){
        
        delegate?.didTapProfilePic()
      
        
    }
    
    
    
    
}
