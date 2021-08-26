//
//  CommentsCollectionViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-17.
//

import UIKit

class CommentsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CommentsCollectionViewCell"
    
    private let imageView : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        
        return view
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        
         
        return label
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)

        clipsToBounds = true
    
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = contentView.bounds

        
    }
    
    public func configure(model: CommentsModel){
        
    
        label.text = "\(model.username) \(model.comment)"
        
        label.attributedText = NSMutableAttributedString().bold("\(model.username)  ").normal("\(model.comment)")
        
        
    }
    
    
    
}
