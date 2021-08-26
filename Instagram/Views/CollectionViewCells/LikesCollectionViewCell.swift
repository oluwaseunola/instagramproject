//
//  LikesCollectionViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-19.
//

import UIKit

protocol LikesCollectionViewCellDelegate: AnyObject{
    func didTapLikes(_ cell: LikesCollectionViewCell, index: Int)
}

class LikesCollectionViewCell: UICollectionViewCell {
     static let identifier = "LikesCollectionViewCell"

    weak var delegate : LikesCollectionViewCellDelegate?
    private var index = 0
    private let label : UILabel = {
        let label = UILabel()
        
        label.text = "120 Likes"
        
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(label)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapLikes))
        
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.height/1.5
        label.frame = CGRect(x: 5, y: (contentView.height-size)/2, width: contentView.width/2, height: size)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }
    
    public func configure(with model: LikesViewModel, index: Int){
        self.index = index
        let users = model.likedBy
        label.text = "\(users.count) Likes"
    }
    
    @objc func didTapLikes(){
        
        delegate?.didTapLikes(self, index: index)

    }
}
