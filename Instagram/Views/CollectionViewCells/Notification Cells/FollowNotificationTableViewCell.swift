//
//  FollowNotificationTableViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-05.
//
import SDWebImage
import UIKit

protocol FollowNotificationTableViewCellDelegate: AnyObject{
    
    func didTapFollower(cell: FollowNotificationTableViewCell, isFollowing: Bool, post: FollowNotificatoinViewModel)
    
}

class FollowNotificationTableViewCell: UITableViewCell {

   static let identifier = "FollowNotificationTableViewCell"

    public weak var delegate : FollowNotificationTableViewCellDelegate?
    
    private var viewModel : FollowNotificatoinViewModel?
    
    private var isFollowing = false

    
    private let followButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
    private let profilePic : UIImageView = {
        let view = UIImageView()
        
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        
        return view
        
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
        
    }()
    
    private let timeStamp : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .left
        
        label.numberOfLines = 1
        
        
        return label
        
    }()
    
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.clipsToBounds = true
        contentView.addSubview(profilePic)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        contentView.addSubview(timeStamp)
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        selectionStyle = .none

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize : CGFloat = contentView.height/2
        
        profilePic.frame = CGRect(x: 10, y: (contentView.height - imageSize)/2, width: imageSize, height: imageSize)
        
        
        profilePic.layer.cornerRadius = imageSize/2
        
        let labelSize = label.sizeThatFits(CGSize(width: contentView.width - profilePic.width - followButton.width - 22, height: contentView.height))
        
        label.frame = CGRect(x: profilePic.right + 10, y: 0, width: labelSize.width-followButton.width, height: contentView.height)
        
        followButton.sizeToFit()
        
        let followButtonSize = followButton.sizeThatFits(bounds.size)
        let buttonWidth: CGFloat = max(followButtonSize.width,90)
        
        followButton.frame = CGRect(x: contentView.width-buttonWidth-22, y: (contentView.height-followButtonSize.height)/2, width: buttonWidth, height: followButtonSize.height)
        
        timeStamp.frame = CGRect(x: 10, y: profilePic.bottom, width: labelSize.width, height: labelSize.height)

        
        
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profilePic.image = nil
        label.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
        timeStamp.text = nil
        
        
        
    }
    
    
    private func updateButton(){
        
        
        followButton.setTitle(self.isFollowing ? "Following" : "Follow", for: .normal)
        
        followButton.backgroundColor = self.isFollowing ? .systemBackground : .systemBlue
        
        followButton.layer.borderWidth  = self.isFollowing ? 2 : 0
        
        followButton.layer.borderColor  = self.isFollowing ? UIColor.secondaryLabel.cgColor : .none
        
    }
    
    @objc func didTapFollowButton(){
        
        guard let vm = viewModel else {
            return
        }
        

        
        delegate?.didTapFollower(cell: self, isFollowing: !self.isFollowing, post: vm)
        
        self.isFollowing = !self.isFollowing
    
        updateButton()
    }
    
   

    
    public func configure(with model: FollowNotificatoinViewModel ){
        self.viewModel = model
        isFollowing = model.followStatus
        
        profilePic.sd_setImage(with: model.profilePic, completed: nil)
        timeStamp.text = model.timeStamp

        
        label.text = "\(model.username) started following you"
        
      
        
        updateButton()
        
    }
    

   

}
