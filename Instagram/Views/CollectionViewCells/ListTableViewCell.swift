//
//  ListTableViewCell.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-20.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    

    static let identifier = "ListTableViewCell"
     
     
     private let profilePic : UIImageView = {
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
     
    
     
     
     

     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         
         contentView.clipsToBounds = true
         contentView.addSubview(profilePic)
         contentView.addSubview(label)

         selectionStyle = .none

     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         
         let imageSize : CGFloat = contentView.height/2
         
         let labelSize = label.sizeThatFits(CGSize(width: contentView.width - profilePic.width - 22, height: contentView.height))
         
         profilePic.frame = CGRect(x: 10, y: (contentView.height - imageSize)/2, width: imageSize, height: imageSize)
         
         label.frame = CGRect(x: profilePic.right + 10, y: 0, width: labelSize.width, height: contentView.height)
         
         
         
         
         profilePic.layer.cornerRadius = imageSize/2
         
         
         
         
     }
     
     
     override func prepareForReuse() {
         super.prepareForReuse()
         
         profilePic.image = nil
         label.text = nil
         
         
         
         
     }
     
     


     
     public func configure(with model: ListViewModel ){
         
         
         
         profilePic.sd_setImage(with: model.profilePic, completed: nil)
         
         label.text = model.username
         
         
     }
     

    


}
