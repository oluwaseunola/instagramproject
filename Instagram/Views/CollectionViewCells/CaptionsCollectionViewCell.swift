//
//  CommentsCollectionViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-19.
//

import UIKit

protocol CaptionsCollectionViewCellDelegate: AnyObject{
    func didTapCaptions(_ cell: CaptionsCollectionViewCell)
}

class CaptionsCollectionViewCell: UICollectionViewCell {
   
    static let identifier = "CaptionsCollectionViewCell"
    weak var delegate : CaptionsCollectionViewCellDelegate?

    private let label : UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        
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
        label.frame = CGRect(x: 5, y: (contentView.height-size)/2, width: contentView.width, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with model: CaptionCollectionViewModel){
        let name = model.username
        
        guard let caption = model.caption else{return}
        
//        let attributes : [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.white,
//            .font: UIFont.boldSystemFont(ofSize: 16)
//        ]
//
//        let attributedString = NSAttributedString(string: name, attributes: attributes)
        
        
        label.text = "\(name) \(caption)"
        
    }
    
    @objc func didTapLikes(){
        
        delegate?.didTapCaptions(self)
        
        

    }
}
