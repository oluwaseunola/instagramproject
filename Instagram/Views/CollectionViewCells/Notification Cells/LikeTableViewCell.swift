//
//  LikeTableViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-05.
//

import UIKit

protocol LikeTableViewCellDelegate: AnyObject{
    
    func didTapPost(cell: LikeTableViewCell, post: LikeNotificationViewModel)
    
}

class LikeTableViewCell: UITableViewCell {

   static let identifier = "LikeTableViewCell"
    
    public weak var delegate : LikeTableViewCellDelegate?
    
    private var viewModel : LikeNotificationViewModel?
    
    private let profilePic : UIImageView = {
        let view = UIImageView()
        
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        
        
        return view
        
    }()
    
    private let postImage : UIImageView = {
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
        contentView.addSubview(postImage)
        contentView.addSubview(timeStamp)
        selectionStyle = .none
        
        postImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postImage.addGestureRecognizer(gesture)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize : CGFloat = contentView.height/2
    
        
        profilePic.frame = CGRect(x: 10, y: (contentView.height - imageSize)/2, width: imageSize, height: imageSize)
        let labelSize = label.sizeThatFits(bounds.size)
        
        profilePic.layer.cornerRadius = imageSize/2

       
        label.frame = CGRect(x: profilePic.right + 10, y: 0, width: labelSize.width, height: contentView.height)
        
        postImage.frame = CGRect(x: contentView.right - 50, y: (contentView.height-30)/2, width: 30, height: 30)
        
        timeStamp.frame = CGRect(x: 10, y: profilePic.bottom+5, width: labelSize.width, height: labelSize.height)

        
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profilePic.image = nil
        label.text = nil
        postImage.image = nil
        timeStamp.text = nil
        
        
    }

    
    public func configure(with model: LikeNotificationViewModel ){
        
        self.viewModel = model
        
        profilePic.sd_setImage(with: model.profilePic, completed: nil)
        postImage.sd_setImage(with: model.postURL, completed: nil)
        
        label.text = "\(model.username) liked your post"
        timeStamp.text = model.timeStamp

    
        
    }
    
    @objc func didTapPost(){
    
        guard let vm = viewModel else{return}
        
        delegate?.didTapPost(cell: self, post: vm)
        
        
        
        
    }

   

}
