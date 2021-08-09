//
//  ActionsCollectionViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-19.
//

import UIKit

protocol ActionsCollectionViewCellDelegate: AnyObject{
    func didTapLikeButton(_ cell: ActionsCollectionViewCell, isLiked: Bool )
    func didTapCommentButton(_ cell: ActionsCollectionViewCell )
    func didTapShareButton(_ cell: ActionsCollectionViewCell )

}
class ActionsCollectionViewCell: UICollectionViewCell {
     static let identifier = "ActionsCollectionViewCell"
    
    private var isLiked = false
    
    weak var delegate : ActionsCollectionViewCellDelegate?
    
    private let like : UIButton = {
        let button = UIButton()

        button.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .semibold)), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let comment : UIButton = {
        let button = UIButton()

        button.setImage(UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .semibold)), for: .normal)
        button.tintColor = .label

        return button
    }()
    
    private let share : UIButton = {
        let button = UIButton()

        button.setImage(UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .semibold)), for: .normal)
        button.tintColor = .label

        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(like)
        contentView.addSubview(comment)
        contentView.addSubview(share)
        
        like.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        comment.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        share.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - button functions
    
    @objc func didTapLikeButton(){
        if isLiked{
            like.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)), for: .normal)
            like.tintColor = .systemRed
        }else{
            like.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .semibold)), for: .normal)
            like.tintColor = .label

        }
        
        delegate?.didTapLikeButton(self, isLiked: !self.isLiked)
        
        self.isLiked = !self.isLiked
        
    }
    
    @objc func didTapCommentButton(){
        
        delegate?.didTapCommentButton(self)
        
    }
    
    @objc func didTapShareButton(){
        
        delegate?.didTapShareButton(self)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size : CGFloat = contentView.height/1.8
        
        like.frame = CGRect(x: 5, y: (contentView.height-size)/2, width: size, height: size)
        comment.frame = CGRect(x: like.right+20, y: (contentView.height-size)/2, width: size, height: size)
        share.frame = CGRect(x: comment.right+20, y: (contentView.height-size)/2, width: size, height: size)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        

    }
    
    public func configure(with model: ActionsViewModel){
        isLiked = model.isLiked
        
    }
}
