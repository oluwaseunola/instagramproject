//
//  FilterCollectionViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-29.
//
import SDWebImage
import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FilterCollectionViewCell"
    
    private let photoView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.tintColor = .label
        
        
        
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photoView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoView.frame = contentView.bounds
    }
    
    func configureCell(with image: UIImage?){
        if let safeImage = image{
        
            photoView.image = safeImage
        }
        
    }
    
    func configureCell(with url: URL){
        
        photoView.sd_setImage(with: url, completed: nil)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
    
    
}
