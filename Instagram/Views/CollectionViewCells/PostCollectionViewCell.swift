//
//  PostCollectionViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-19.
//
import SDWebImage
import UIKit

protocol PostCollectionViewCellDelegate: AnyObject{
    
    func didTapLike(_ cell: PostCollectionViewCell)
    
}

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    
    weak var delegate : PostCollectionViewCellDelegate?
    
    private let image : UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    
    private let heartImage : UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.image = UIImage(systemName: "heart.fill")
        view.tintColor = .white
        
        
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.addSubview(image)
        contentView.addSubview(heartImage)
        heartImage.isHidden = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapPost))
        
        gesture.numberOfTapsRequired = 2
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(gesture)
        configureHeart()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.width-100
        image.frame = contentView.bounds
        heartImage.frame = CGRect(x: (size)/2, y: (size)/2 , width: 100, height: 100)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
    
    public func configure(with model: PostCollectionViewModel){
        image.sd_setImage(with: model.post, completed: nil)
    }
    
    @objc func didDoubleTapPost(){
        
        delegate?.didTapLike(self)
        
        heartImage.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.heartImage.alpha = 1
        }) { done in
            
            if done{
                UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .beginFromCurrentState, animations: {
                    self.heartImage.alpha = 0

                }) { done in
                    
                    if done{
                        
                        self.heartImage.isHidden = true

                    }
                }
                

            }
        }
        
    }
    
    func configureHeart(){
        heartImage.clipsToBounds = false
        heartImage.layer.shadowColor = UIColor.black.cgColor
        heartImage.layer.shadowOpacity = 1
        heartImage.layer.shadowOffset = CGSize.zero
        heartImage.layer.shadowRadius = 10
        heartImage.layer.shadowPath = UIBezierPath(roundedRect: heartImage.bounds, cornerRadius: 10).cgPath
    }
}
