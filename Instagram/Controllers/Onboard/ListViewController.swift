//
//  ListViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    

    var usernames : [String] 
    
    private var viewModel :  [ListViewModel] = []
    
    init(usernames: [String]) {
        self.usernames = usernames
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configure()
       
        
        

    }
    
    

    
    private var tableView : UITableView?
       
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       
    }
    
    private func configure(){
        
        usernames.forEach { username in
            
            StorageManager.shared.downloadPicURL(for: username) {  url in
               
                guard let url = url else {
                    return
                }
            
                let model = ListViewModel(username: username, profilePic: url)
                
                
            
                self.viewModel.append(model)
                
                self.configureTableView()
             

                
                
            }
            
        }
        
    }
    
    private func configureTableView(){
        
        
        let tableView = UITableView()
        
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView = tableView
        tableView.frame = view.bounds
    }
    
    
    //MARK: - delegate functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath)
                as? ListTableViewCell else {return UITableViewCell()}
    
      
        
        let model = viewModel[indexPath.row]
    
            cell.configure(with: model)
    

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
