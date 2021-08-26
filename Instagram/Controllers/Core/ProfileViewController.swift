//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ProfileHeaderCountViewDelegate, HeaderCollectionReusableViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    
    
    
    let imagePicker = UIImagePickerController()

    let user : User
    
    var observer : NSObjectProtocol?
    
    var currentUser : Bool {
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username") ?? "".lowercased()
    }
    
    
    private var collectionView : UICollectionView?
    
    private var userPostModels : [Post] = []
    
    private var headerViewModel : ProfileHeaderViewModel?
    
    
    
    
    
    //MARK: - Initializer
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.username
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(didTapSettings))
        
        barButton.tintColor = .white
        navigationItem.rightBarButtonItem = barButton
        
        configureNavBarButton()
        configureCollectionView()
        //        mock()
        fetchProfileData()
        
        if currentUser{
            observer = NotificationCenter.default.addObserver(forName: .didPostNotification, object: nil, queue: .main, using: { [weak self] _ in
                
                self?.userPostModels.removeAll()
                self?.fetchProfileData()
            })
        }
        
        
    }
    
    
    
    
    
    
    private func configureNavBarButton(){
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(didTapSettings))
        
        
    }
    
    @objc func didTapSettings(){
        let settings = SettingsViewController()
        settings.title = "Settings"
        present(UINavigationController(rootViewController: settings), animated: true, completion: nil)
    }
    
    private func configureCollectionView(){
        let layout = UICollectionViewCompositionalLayout { section, _ in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33)), subitem: item, count: 3)
            
            
            let section = NSCollectionLayoutSection(group: group)
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.75)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            
            section.boundarySupplementaryItems = [header]
            
            return section
            
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        
        self.collectionView = collectionView
        view.addSubview(collectionView)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
    
    private func mock (){
        guard let url = URL(string: "https://i.ytimg.com/vi/FACbOpdsgCg/maxresdefault.jpg") else {return}
        
        headerViewModel = ProfileHeaderViewModel(profilePicURL: url, followerCount: 2000, followingCount: 14, postCount: 2000, bio: "What's good ya'll", name: "Seun Olalekan", buttonType: .currentUser)
    }
    
    
    //MARK: - Fetch Data
    
    private func fetchProfileData(){
        
        
        
        
        var profilePic : URL?
        var buttonType : ProfileButtonState = .currentUser
        
        var bio : String?
        var name : String?
        
        
        var followers = 0
        var posts = 0
        var following = 0
        
        
        
        let group = DispatchGroup()
        
        group.enter()
        StorageManager.shared.downloadPicURL(for: user.username) { picURL in
            
            defer{group.leave()}
            
            profilePic = picURL
            
        }
        
        if !currentUser{
            
            group.enter()
            
            DatabaseManager.shared.isFollowing(targetuser: user.username) { followStatus in
                defer{group.leave()}
                
                buttonType = .visitor(isFollowing: followStatus)
            }
            
            
        }
        
        group.enter()
        
        DatabaseManager.shared.fetchFollowerCount(with: user.username) { results in
            defer{group.leave()}
            
            followers = results.follower
            following = results.following
            posts = results.post
        }
        
        
        group.enter()
        DatabaseManager.shared.getInfo(for: user.username) { info in
            
            defer{group.leave()}
            
            bio = info?.bio
            name = info?.name
            
            
        }
        
        
        guard let username = UserDefaults.standard.string(forKey: "username") else{return}
        
        group.enter()
        
        DatabaseManager.shared.retrievePost(for: username) { [weak self] result in
            
            defer{group.leave()}
            
            switch result{
            case.success(let posts):
                
                DispatchQueue.main.async {
                    self?.userPostModels = posts
                }
            case.failure(let error):
                
                break
            }
            
            
        }
        
        
        group.notify(queue: .main) {
            
            
            let viewModel = ProfileHeaderViewModel(profilePicURL: profilePic, followerCount: followers, followingCount: following, postCount: posts, bio: bio, name: name, buttonType: .currentUser)
            
            self.headerViewModel = viewModel
            
            self.collectionView?.reloadData()
            
            
        }
        
        
    }
    
    
    //MARK: - CollectionView delegate/data source functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPostModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else {return UICollectionViewCell()}
        
        guard let post = URL(string:userPostModels[indexPath.row].postDownloadURL) else {return UICollectionViewCell()}
        
        let viewModel = PostCollectionViewModel(post: post )
        
        cell.configure(with: viewModel, index: indexPath.section)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let post = userPostModels[indexPath.row]
        
        let postVC = PostViewController(post: post, owner: user.username )
        
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader, let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView else{return UICollectionReusableView()}
        
        
        if let viewModel = headerViewModel{
            
            headerView.configure(with: viewModel)
            headerView.countContainerView.delegate = self
            headerView.delegate = self
            
            
        }
        
        
        
        
        
        
        
        
        return headerView
        
        
        
        
        
    }
    
    //MARK: - Count Delegate Functions
    
    func didTapPosts() {
        
        collectionView?.scrollsToTop = true
        
        
    }
    
    func didTapFollowers() {
        
        
    }
    
    func didTapFollowing() {
        
    }
    
    //MARK: - headerview delegates
    
    func didTapFollow() {
    }
    
    func didTapUnfollow() {
        
    }
    
    func didTapEdit() {
        
        print("hi")
        let vc = EditViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.completion = { [weak self] in
            self?.headerViewModel = nil
            self?.fetchProfileData()
            
            
        }
        present(nav ,animated: true, completion: nil)
        
    }
    
    func didTapProfilePic() {
        
        guard let username = UserDefaults.standard.string(forKey: "username") else{return}
        
        let actionsheet = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        let removePhoto = UIAlertAction(title: "Remove Current Photo", style: .default) { action in
            
            let image = UIImage(systemName: "person.circle")?.pngData()
            
            let alert = UIAlertController(title: "Remove Profile", message: "Are you sure you want to remove your profile picture?", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Yes", style: .destructive) { action in
                
                StorageManager.shared.uploadProfilePicture(username: username , picture: image) { [weak self] success in
                    
                    if success{
                        
                        print("success")
                        self?.fetchProfileData()
                        
                        
                        
                    }
                }
            }
            
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alert.addAction(yes)
            alert.addAction(no)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let changeProfilePicture = UIAlertAction(title: "Change Profile Picture", style: .default) { [weak self] action in
           
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                self?.imagePicker.delegate = self
                self?.imagePicker.sourceType = .photoLibrary
                self?.imagePicker.allowsEditing = true
                
                if let imagepicker = self?.imagePicker{
                    self?.present(imagepicker, animated: true, completion: nil)
                }
                
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        
        
        actionsheet.addAction(removePhoto)
        actionsheet.addAction(changeProfilePicture)
        actionsheet.addAction(cancel)
        
        present(actionsheet, animated: true, completion: nil)
        
        
        
    }
    
    
    //MARK: - Image Picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let chosenImage = info[.editedImage] as? UIImage {
            
            guard let username = UserDefaults.standard.string(forKey: "username") else {return}
            
            StorageManager.shared.uploadProfilePicture(username: username, picture: chosenImage.pngData()) { success in
                
                
                if success{
                    print("changed")
                    self.fetchProfileData()
                }
            }
            
        }
        
        
        
        
    }
  
    
}
