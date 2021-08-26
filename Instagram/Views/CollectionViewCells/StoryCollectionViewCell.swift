//
//  StoryCollectionViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-23.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "StoryCollectionViewCell"
    
    private let profilePic : UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        
        return view
        
    }()
    
    private let label : UILabel = {
        let view = UILabel()
        
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 12)
        view.textAlignment = .center
        
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(profilePic)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profilePic.image = nil
        label.text = nil
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.sizeToFit()
        
        label.frame = CGRect(x: (contentView.width - label.width)/2, y:(contentView.height - label.height - 3) , width: label.width, height: label.height)
       
        let imageSize : CGFloat = contentView.height - label.height - 12
        profilePic.frame = CGRect(x: (contentView.width - imageSize)/2, y: 2, width: imageSize, height: imageSize)
        
        profilePic.layer.cornerRadius = imageSize/2
        
        
        
    }
    
    func configure(with model: Story){
       
        label.text = model.username
        profilePic.image = model.story
        
        
    }
    
    
    
}
