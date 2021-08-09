//
//  PosterCollectionViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-19.
//
import SDWebImage
import UIKit

protocol PosterCollectionViewCellDelegate: AnyObject {
    func posterCollectionViewCellDidtapMore(_ cell: PosterCollectionViewCell)
    func didTapUsername(_ cell: PosterCollectionViewCell)
    
}

class PosterCollectionViewCell: UICollectionViewCell {
    static let identifier = "PosterCollectionViewCell"
    
    weak var delegate : PosterCollectionViewCellDelegate?
    
    private let profilePic : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        
        
        
        return view
    }()
    
    private let username : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
        
    }()
    private let optionsButton : UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .label
        
        return button
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(profilePic)
        contentView.addSubview(username)
        contentView.addSubview(optionsButton)
        optionsButton.addTarget(self, action: #selector(didTapOptionsButton), for: .touchUpInside)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapUsername))
        
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        username.isUserInteractionEnabled = true
        username.addGestureRecognizer(gesture)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding : CGFloat = 6
        let size : CGFloat = contentView.height - (padding * 2)
        profilePic.frame = CGRect(x: padding, y: padding, width: size, height: size)
        profilePic.layer.cornerRadius = size/2
        
        username.sizeToFit()
        
        username.frame = CGRect(x: profilePic.right+10, y: 0, width: username.width, height: contentView.height)
        
        optionsButton.frame = CGRect(x: contentView.right - 70, y: (contentView.height-100)/2, width: 100, height: 100)
        
        
        
        
    }
    
    @objc func didTapOptionsButton(){
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        delegate?.posterCollectionViewCellDidtapMore(self)
        
        
        
    }
    
    @objc func didTapUsername(){
        
        delegate?.didTapUsername(self)
        
        
        
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profilePic.image = nil
        username.text = nil
    }
    
    public func configure(with model: PosterCollectionViewModel){
        
        username.text = model.username
        
        profilePic.sd_setImage(with: model.image, completed: nil)
        
        
    }
    
    
}
