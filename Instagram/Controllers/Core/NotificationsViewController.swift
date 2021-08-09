//
//  NotificationsViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CommentNotificationTableViewCellDelegate, FollowNotificationTableViewCellDelegate, LikeTableViewCellDelegate {
   
    
    
    
    
    
   
    
  
    private let noNotificationsLabel : UILabel = {
        let label = UILabel()
        
        label.text = "No notification"
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    private var notificationViewModels : [NotificationCellType] = []
    
    private var models : [IGNotificaton] = []

    private let tableView : UITableView = {
        let view = UITableView()
        
        view.isHidden = false
        
        view.register(FollowNotificationTableViewCell.self, forCellReuseIdentifier: FollowNotificationTableViewCell.identifier)
        
        view.register(LikeTableViewCell.self, forCellReuseIdentifier: LikeTableViewCell.identifier)
        
        view.register(CommentNotificationTableViewCell.self, forCellReuseIdentifier: CommentNotificationTableViewCell.identifier)
        
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(noNotificationsLabel)
        tableView.delegate = self
        tableView.dataSource = self
//        fetchNotifications()
        mock()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        noNotificationsLabel.sizeToFit()
        noNotificationsLabel.center = view.center
    }
    
    
    private func fetchNotifications(){
        
        NotificationsManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.models = notifications
                self?.configureViewModels()

            }
            
            
            
        }
        
        
        
    }
    
    private func configureViewModels(){
        models.forEach { model in
            
            guard let type = NotificationsManager.IGtype(rawValue: model.notificationType) else {return}
            
            let username = model.username
            
            guard let profileURL = URL(string: model.profilePic) else {return}
            guard let unwrappedPost = model.postURL else {return}
            guard let postURL = URL(string: unwrappedPost) else {return}
            guard let isFollowing = model.isFollowing else {return}
            switch type{
                
            case.like:
                notificationViewModels.append(.likeNotification(viewModel: LikeNotificationViewModel(profilePic: profileURL , username: username, postURL: postURL, timeStamp: model.timeStamp)))
            case .comment:
                notificationViewModels.append(.commmentNotificatoin(viewModel: CommentNotificationViewModel(profilePic: profileURL, username: username, postURL: postURL, timeStamp: model.timeStamp)))
            case .follow:
                notificationViewModels.append(.followNotification(viewModel: FollowNotificatoinViewModel(profilePic: profileURL, username: username, followStatus: isFollowing, timeStamp: model.timeStamp)))
            }
            
        }
        
        if notificationViewModels.isEmpty{
            noNotificationsLabel.isHidden = false
            tableView.isHidden = true
        } else{
            noNotificationsLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()}
    }
    
    
    private func mock(){
        
        guard let url = URL(string: "https://img.jamesedition.com/listing_images/2021/05/14/12/53/52/af1e4ff6-acac-40ae-9488-e11e53b0b573/je/1040x620xc.jpg") else{return}
       
        let mockdata : [NotificationCellType] = [.likeNotification(viewModel: LikeNotificationViewModel(profilePic: url, username: "BenBaller", postURL: url, timeStamp: Date().makeDate(date: Date())!)), .followNotification(viewModel: FollowNotificatoinViewModel(profilePic: url, username: "JimmyBoi", followStatus: true, timeStamp: Date().makeDate(date: Date())!)), .commmentNotificatoin(viewModel: CommentNotificationViewModel(profilePic: url, username: "Eddie Huang", postURL: url, timeStamp: Date().makeDate(date: Date())!))]
        
        notificationViewModels.append(contentsOf: mockdata)
        
        tableView.reloadData()
        
    }

    
    //MARK: - TableView Delegate functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = notificationViewModels[indexPath.row]
        
        switch cellType{
            
        case.commmentNotificatoin(let comment):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentNotificationTableViewCell.identifier, for: indexPath) as? CommentNotificationTableViewCell else {return UITableViewCell()}
            
            cell.delegate = self
            
            cell.configure(with: comment)
            
            return cell
    
            
        case.followNotification(let follower):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowNotificationTableViewCell.identifier, for: indexPath) as? FollowNotificationTableViewCell else {return UITableViewCell()}
            
            cell.configure(with: follower)
            
            cell.delegate = self
            
            return cell
            
        case.likeNotification(let like):
            
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeTableViewCell.identifier, for: indexPath) as? LikeTableViewCell else {return UITableViewCell()}
            
            
            cell.configure(with: like)
            cell.delegate = self
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let celltype = notificationViewModels[indexPath.row]
        
        let username : String
        
        switch celltype{
            
        case.likeNotification(let viewModel):
            username = viewModel.username
            
        case.commmentNotificatoin(let viewModel):
            username = viewModel.username

            
        case.followNotification(let viewModel):
            username = viewModel.username

        }
        
        DatabaseManager.shared.findUsername(with: username) { [weak self] user in
            
            guard let user = user else {
                return
            }
            DispatchQueue.main.async {
                let userProfile = ProfileViewController(user: user)
                
                self?.navigationController?.pushViewController(userProfile, animated: true)
            }
           
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    //MARK: - Delegate actions
    
    
    func findIndex(index: Int, userName: String ){
        

        guard index < models.count else{return}
        
        let model = models[index]
        
        let username = userName
        

        
        guard let postID = model.postID else {return}
        
        

        
        DatabaseManager.shared.aquirePostID(username: username, post: postID) { [weak self] post in
            
            DispatchQueue.main.async {
                
                guard let post = post else {
                    
                    let alert = UIAlertController(title: "Error", message: "Could not retrieve post", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                    
                    alert.addAction(action)
                    
                    self?.present(alert, animated: true, completion: nil)
                    
    
                    
                    return
                    
                }

                let vc = PostViewController(post: post)
                
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func didTapPost(cell: CommentNotificationTableViewCell, post: CommentNotificationViewModel) {
        
        

        guard let index = notificationViewModels.firstIndex(where: {
            switch $0{
            case.commmentNotificatoin(let commentModel):

                return commentModel == post
            case .followNotification:
                return false
            case .likeNotification:
                return false
            }
            
             }) else {return}
        
        

        
        findIndex(index: index, userName: post.username )
        
        
    }
    
    func didTapFollower(cell: FollowNotificationTableViewCell, isFollowing: Bool, post: FollowNotificatoinViewModel) {
        
        let username = post.username
        
        DatabaseManager.shared.updateRelationship(state: isFollowing ? .unfollow : .follow, for: username) { success in

        }
        
        
        
        
    }
    
    
    func didTapPost(cell: LikeTableViewCell, post: LikeNotificationViewModel) {
        
        guard let index = notificationViewModels.firstIndex(where: {
            switch $0{
            case.likeNotification(let likeModel):
                return likeModel == post
            case .followNotification:
                return false
            case .commmentNotificatoin:
                return false
            }
            
             }) else {return}
        
        
        findIndex(index: index, userName: post.username)
        

    }
    
    

}
