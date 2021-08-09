//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class SettingsViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    let signOutLabel : UILabel = {
        let label = UILabel()
        label.text = "Log Out"
        label.textColor = .systemBlue
        return label
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureTableFooter()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSignout))
        gesture.numberOfTapsRequired = 1
        signOutLabel.addGestureRecognizer(gesture)
        signOutLabel.isUserInteractionEnabled = true
        
        
    }
    
    @objc func didTapSignout(){
        
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to be logged out?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Log Out", style: .default) { action in
            
                
                AuthManager.shared.logOutUser {[weak self] loggedout in
                   
                    if loggedout{
                        
                        DispatchQueue.main.async {
                       
                            print("Success")
                            let vc = LoginViewController()
                            let navVc = UINavigationController(rootViewController: vc)
                            navVc.modalPresentationStyle = .fullScreen
                            self?.present(navVc, animated: true, completion: nil)
                        }
                        
                    }else{print("something went wrong")}
                    
                }
            
        }
        
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
        
       
        
       
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        signOutLabel.frame = CGRect(x: 10, y: 0, width: view.width, height: 40)
    }
    
    private func configureTableFooter(){
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 40))
        
        footer.addSubview(signOutLabel)
    
        tableView.tableFooterView = footer
    }
    


}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
}
