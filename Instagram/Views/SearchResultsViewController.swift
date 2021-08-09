//
//  SearchResultsViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-02.
//

import UIKit

protocol SearchResultsViewControllerDelegate : AnyObject{
    func didTapProfile(user: User)
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate : SearchResultsViewControllerDelegate?
    
    private var users : [User] = []
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        
        tableView.isHidden = true
        
        
        return tableView
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    public func update(with users: [User]){
        
        self.users = users
        tableView.reloadData()
        tableView.isHidden = users.isEmpty
        

    }
    
    //MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.didTapProfile(user: users[indexPath.row])
        
        
    }

}
