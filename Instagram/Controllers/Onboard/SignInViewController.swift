//
//  LoginViewController.swift
//  InstaApp
//
//  Created by Seun Olalekan on 2021-06-12.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    
    struct Constants {
        static let cornerRadius : CGFloat = 8.0
    }
    
    private let usernameField: UITextField = {
        
        let field = UITextField()
        
        field.placeholder = "Username or Email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        
        return field
    }()
    
    private let userEmailField: UITextField = {
        
        let field = UITextField()
        
        field.placeholder = "Username or Email..."
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Terms and Conditions", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        
        
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        
        
        return button
    }()
    
    private let createAccountButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitleColor(.label, for: .normal)
        button.setTitle("New User? Create an Account", for: .normal)
        
        return button
    }()
    
    private let headerView : UIView = {
        
        let header = UIView()
        let backgroundImageView = UIImageView(image: UIImage(named: "Gradient"))
        header.addSubview(backgroundImageView)
        header.clipsToBounds = true
        
        
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapAccountButton), for: .touchUpInside)
        
        userEmailField.delegate = self
        passwordField.delegate = self
        
        addSubViews()
        view.backgroundColor = .systemBackground
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.height/3.0)
        userEmailField.frame = CGRect(x: 25, y: headerView.bottom + 10, width: view.width - 50, height: 52)
        passwordField.frame = CGRect(x: 25, y: userEmailField.bottom + 10, width: view.width - 50, height: 52)
        loginButton.frame = CGRect(x: 25, y: passwordField.bottom + 10, width: view.width - 50, height: 52)
        createAccountButton.frame = CGRect(x: 25, y: loginButton.bottom + 10, width: view.width - 50, height: 52)
        termsButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 100 , width: view.width - 20, height: 50)
        privacyButton.frame = CGRect(x: 10, y: view.height - view.safeAreaInsets.bottom - 50 , width: view.width - 20, height: 50)
        configureHeaderView()
        
        
        
        
    }
    
    private func configureHeaderView(){
        
        guard headerView.subviews.count == 1 else{
            return
        }
        
        guard let backgroundView = headerView.subviews.first else{
            return
            
        }
        
        backgroundView.frame = headerView.bounds
        let imageView = UIImageView(image: UIImage(named: "Instagram"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4, y: view.safeAreaInsets.top , width: headerView.width/2, height: (headerView.height - headerView.safeAreaInsets.top) )
        headerView.addSubview(imageView)
    }
    
    
    
    private func addSubViews(){
        view.addSubview(usernameField)
        view.addSubview(userEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(privacyButton)
        view.addSubview(termsButton)
        view.addSubview(createAccountButton)
        view.addSubview(headerView)
        
    }
    
    @objc private func didTapLoginButton(){
        
        passwordField.resignFirstResponder()
        userEmailField.resignFirstResponder()
        
        guard let emailFieldText = userEmailField.text, !emailFieldText.isEmpty else {
            return
        }
        guard  let passwordFieldText = passwordField.text, !passwordFieldText.isEmpty, passwordFieldText.count >= 8 else {
            return
        }
        
        var username : String?
        var email : String?
        
        
        if emailFieldText.contains("@"), emailFieldText.contains(".") {
             email = emailFieldText
            
        }else{
            username = emailFieldText
            
        }
        
        guard let email = email else {
            return
        }

         AuthManager.shared.signIn(email: email, password: passwordFieldText, username: passwordFieldText) { [weak self] result in
            
             
             
             
            DispatchQueue.main.async {
                
                switch result{
                    
                case.success:
                    
                    HapticsViewController.shared.vibrate(for: .success)
                    let vc = TabViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true, completion: nil)
                    
                case.failure(let error):
                    HapticsViewController.shared.vibrate(for: .error)
                    let alert = UIAlertController(title: "Error", message: "There was an error logging you in.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self?.present(alert, animated: true, completion: nil)
                    print(error)
                }
            }
           
                
            
        }
        
        
    }
    
    @objc private func didTapPrivacyButton(){
        
        if let urlString = URL(string: "https://help.instagram.com/519522125107875/?helpref=hc_fnav&bc[0]=Instagram%20Help&bc[1]=Policies%20and%20Reporting"){
            
            let privacyLink = SFSafariViewController(url: urlString)
            
            present(privacyLink, animated: true)
        }
        
        
        
    }
    @objc private func didTapTermsButton(){
        
        if let urlLink = URL(string: "https://help.instagram.com/581066165581870/?helpref=hc_fnav&bc[0]=Instagram%20Help&bc[1]=Policies%20and%20Reporting"){
            
            let termsLink = SFSafariViewController(url: urlLink)
            
            present(termsLink, animated: true)
        }
        
    }
    @objc private func didTapAccountButton(){
        
        let vc = RegistrationViewController()
        vc.completion = {
            DispatchQueue.main.async { [weak self] in
                let tabVC = TabViewController()
                let navVC = UINavigationController(rootViewController: tabVC)
                navVC.modalPresentationStyle = .fullScreen
                self?.present(navVC, animated: true)
              print("hi")
                

            }
        }
        vc.title = "Register"
        
        present(UINavigationController(rootViewController: vc), animated: true)
        
    }
    
    
    
    
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userEmailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapLoginButton()
        }
        return true
    }
}
