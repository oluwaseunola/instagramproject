//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import SafariServices
import UIKit

class SettingsViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private var sections : [SettingsSections] = []
    
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
        configureModels()
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
    
    
    private func configureModels(){
        
        guard let url = URL(string: "https://help.instagram.com/519522125107875") else {return}
        
        sections.append(SettingsSections(title: "App", options: [SettingOptions(title: "Rate App", image: UIImage(systemName: "star"), handler: {
            
            
            let controller = SFSafariViewController(url: url )
            
            self.present(controller, animated: true, completion: nil)
            
        }), SettingOptions(title: "Share App", image: UIImage(systemName: "square.and.arrow.up"), handler: {
            
            
            
            let controller = UIActivityViewController(activityItems: ["Share", url ], applicationActivities: [])
            
            self.present(controller, animated: true, completion: nil)
            
        })]))
        
        sections.append(SettingsSections(title: "Information", options: [SettingOptions(title: "Terms of Service ", image: UIImage(systemName: "doc.text.magnifyingglass"), handler: {
            
            
           
            let controller = SFSafariViewController(url: url )
            
            self.present(controller, animated: true, completion: nil)
        }), SettingOptions(title: "Privacy Policy", image: UIImage(systemName: "hand.raised"), handler: {
            
           
           
            let controller = SFSafariViewController(url: url )
            
            self.present(controller, animated: true, completion: nil)
            
        })]))
        
        

                           
                           


}
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = sections[indexPath.section].options[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = model.title
        
        cell.imageView?.image = model.image
        
        cell.accessoryType = .disclosureIndicator
        
        
        
        
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        let title = sections[section].title
        
        return title
    }
}

