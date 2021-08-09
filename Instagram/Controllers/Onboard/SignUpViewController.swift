//
//  RegistrationViewController.swift
//  InstaApp
//
//  Created by Seun Olalekan on 2021-06-12.
//

import UIKit


class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        userEmailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(profilePic)
        view.addSubview(usernameField)
        view.addSubview(userEmailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
        
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        profilePic.isUserInteractionEnabled = true
        
        
        profilePic.addGestureRecognizer(gesture)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        profilePic.frame = CGRect(x: (view.width-90)/2, y: view.safeAreaInsets.top + 100, width: 90, height: 90)
        usernameField.frame = CGRect(x: 25, y: view.safeAreaInsets.top + 250, width: view.width - 40, height: 52)
        userEmailField.frame = CGRect(x: 25, y: usernameField.bottom + 10, width: view.width - 40, height: 52)
        passwordField.frame = CGRect(x: 25, y: userEmailField.bottom + 10, width: view.width - 40, height: 52)
        registerButton.frame = CGRect(x: 25, y: passwordField.bottom + 10, width: view.width - 40, height: 52)
    }
    
    
    struct Constants {
        static let cornerRadius : CGFloat = 8.0
    }
    
    public var completion : (()->Void)?
    
    private let profilePic : UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "person.circle")
        view.tintColor = .label
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 45
        
        
        return view
        
    }()
    
    private let usernameField: UITextField = {
        
        let field = UITextField()
        
        field.placeholder = "Username..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return field
    }()
    
    private let userEmailField: UITextField = {
        
        let field = UITextField()
        
        field.placeholder = "Email..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return field
    }()
    
    private let passwordField: UITextField = {
        
        let field = UITextField()
    
        field.placeholder = "Password"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
        
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    @objc private func didTapRegister(){
        userEmailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = userEmailField.text, !email.isEmpty,
              let name = usernameField.text, !name.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 6
        else{
            return
            
        }
        
        let imageData = profilePic.image?.pngData()
        
        AuthManager.shared.registerNewUser(email: email, password: password, username: name, profilePic: imageData) { [weak self] result in
            switch result{
            case.success(let user):
                UserDefaults.standard.set(user.email, forKey: "email")
                UserDefaults.standard.set(user.username, forKey: "username")
                
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                    let vc = TabViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                    self?.completion?()
                }
                
                
            case.failure(let error): print(error)
            }
            
        }
        
    }
    
    @objc private func didTapProfile(){
    
        
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        let actionsheet = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        let removeCurrentPhoto = UIAlertAction(title: "Remove Current Photo", style: .destructive) { _ in
            self.profilePic.image = UIImage(systemName: "person.circle")
        }
        
        let changeProfilePic = UIAlertAction(title: "Change Profile Picture", style: .default) { _ in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { _ in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionsheet.addAction(removeCurrentPhoto)
        actionsheet.addAction(changeProfilePic)
        actionsheet.addAction(takePhoto)
        actionsheet.addAction(cancel)
        
        present(actionsheet, animated: true, completion: nil)
        
    }
  
}

extension RegistrationViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameField{
            usernameField.becomeFirstResponder()
        }else if textField == userEmailField {
            userEmailField.becomeFirstResponder()
        }else{
            didTapRegister()
        }
        
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let chosenImage = info[.editedImage] as? UIImage{
            profilePic.image = chosenImage
        }
        
    }
    
}

