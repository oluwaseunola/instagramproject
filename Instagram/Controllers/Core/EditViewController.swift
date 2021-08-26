//
//  EditViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-11.
//

import UIKit

class EditViewController: UIViewController {

    private var userInfo : UserInfo?
    
    var completion : (() ->Void)?
    
    override func viewDidLoad() {
        title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        
        
        modalPresentationStyle = .fullScreen
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(nameField)
        view.addSubview(bioField)
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        DatabaseManager.shared.getInfo(for: username) { [weak self] info in
            DispatchQueue.main.async {
                self?.bioField.text = info?.bio
                self?.nameField.text = info?.name
            }
        }
    }
    
    let nameField : UITextField = {
        let field = UITextField()
        
        field.placeholder = "Username"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8
        field.backgroundColor = .secondarySystemBackground
        
        return field
    }()
   
    let bioField : UITextView = {
       let field = UITextView()
        
        field.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
    
        
        return field
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameField.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.width - 40, height: 50)
        bioField.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 70, width: view.width - 40, height: 120)

    }
    
    
    
    @objc func didTapClose(){
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func didTapSave(){
        
        let name = nameField.text ?? ""
        let bio = bioField.text ?? ""
        
        let userInfo = UserInfo(name: name, bio: bio)
        
        DatabaseManager.shared.setInfo(info: userInfo) { [weak self] success in
            if success{
                
                DispatchQueue.main.async {
                    self?.completion?()
                    self?.didTapClose()
                }
                
            }
        }
        
    }
    
    
}
