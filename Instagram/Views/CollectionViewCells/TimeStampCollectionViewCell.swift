//
//  TimeStampCollectionViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-19.
//

import UIKit

class TimeStampCollectionViewCell: UICollectionViewCell {
    static let identifier = "TimeStampCollectionViewCell"
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "34 minutes ago"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(label)
        
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
    
    public func configure(with model: DateTimeCollectionViewModel){
        
         label.text = model.date.makeDate(date: model.date)
        
    }
    
    
    
}
