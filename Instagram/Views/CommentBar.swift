//
//  CommentBar.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-18.
//

import UIKit

protocol CommentBarDelegate: AnyObject{
    func didTapPost(commentBar: CommentBar, text: String)
}


class CommentBar: UIView {

    weak var delegate : CommentBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(textField)
        addSubview(button)
        clipsToBounds = true
        button.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    let textField : UITextField = {
        let view = UITextField()
       
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 7
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return UITextField() }
        
        view.placeholder = " comment as \(username)"
        
        return view
    }()
    
    let button : UIButton = {
        let button = UIButton()
        
        button.setTitle("Post", for: .normal)
        
        
        
        
        
        return button
        
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = CGRect(x: 5, y: (height-(height-20))/2, width: width * (4/5), height: height-20)
        button.frame = CGRect(x: textField.right + 5, y: (height-button.height)/2, width: width - textField.width - 5, height: textField.height)
        
    }

    @objc func didTapPost(){
        guard let safeText = textField.text, !safeText.trimmingCharacters(in: .whitespaces).isEmpty else{return}
       
        delegate?.didTapPost(commentBar: self, text: safeText)
        
        }
    
}
