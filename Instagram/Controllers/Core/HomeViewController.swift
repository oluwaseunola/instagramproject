//
//  ViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var observer : NSObjectProtocol?
    private var collectionView : UICollectionView?
    private var viewModels = [[HomeViewCellsType]]()
    private var allPost : [(post: Post, user: User)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Instagram"
       
        configureCollectionView()
        fetchPost()
        allPosts()
        
        observer = NotificationCenter.default.addObserver(forName: .didPostNotification, object: nil, queue: .main, using: { [weak self] _ in
            
            self?.viewModels.removeAll()
            self?.fetchPost()
        })

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = false

    }
    
    override func viewDidLayoutSubviews() {
        collectionView?.frame = view.bounds
    }
    
    private func allPosts(){
        
        DatabaseManager.shared.explorePosts { result in
            self.allPost = result
        }
        
    }
    
    
    private func fetchPost(){
        
        guard let user = UserDefaults.standard.string(forKey: "username") else {return}
        
        let userGroup = DispatchGroup()
        
        userGroup.enter()
        DatabaseManager.shared.following(username: user) { users in
            for user in users{
                let name = user.username
                
                userGroup.enter()
                DatabaseManager.shared.retrievePost(for: name) { [weak self] result in
                    switch result{
                    case.success(let posts):
                        
                        let group = DispatchGroup()
                        
                        posts.forEach { model in
                            
                            group.enter()
                            
                            self?.createViewModel(model: model, username: name) { success in
                                defer{
                                    
                                    group.leave()
                                }
                                
                                if !success{
                                    
                                    print("something went wrong")
                                }
                                
                                
                                
                                
                            }
                            
                            }
                        group.notify(queue: .global()) {
                            userGroup.leave()
                            
                        }
                        
                        
                        
                        
                    case.failure(let error):
                        print(error)
                    }
                }
                
            }
            
            userGroup.notify(queue: .main) {
                
                self.collectionView?.reloadData()
            }
        }
        
        DatabaseManager.shared.retrievePost(for: user) { [weak self] result in
            switch result{
            case.success(let posts):
                
                let group = DispatchGroup()
                
                posts.forEach { model in
                    group.enter()
                    
                    self?.createViewModel(model: model, username: user) { success in
                        defer{
                            
                            group.leave()
                        }
                        
                        if !success{
                            
                            print("something went wrong")
                        }
                        
                        
                        
                        
                    }
                    
                    }
                group.notify(queue: .main) {
                    self?.sortData()
                    self?.collectionView?.reloadData()
                }
                
                
                
                
            case.failure(let error):
                print(error)
            }
        }
   
        
       
        collectionView?.reloadData()
    }
    
    private func createViewModel(model: Post, username: String, completion: @escaping ((Bool)->Void)){
        
        
        guard let currentUser = UserDefaults.standard.string(forKey: "username") else {return}
        
        
        StorageManager.shared.downloadPicURL(for: username) { url in
            
            guard let postURL = URL(string: model.postDownloadURL) else{return}

            guard let picURL = url else{return}
            
            let isLiked = model.likers.contains(currentUser)
            

        
            let postData : [HomeViewCellsType] = [.poster(viewModel: PosterCollectionViewModel(image: picURL , username: username)), .post(viewModel: PostCollectionViewModel(post: postURL)), .actions(viewModel: ActionsViewModel(isLiked: isLiked)),.likes(viewModel: LikesViewModel(likedBy: model.likers)), .caption(viewModel: CaptionCollectionViewModel(username: username, caption: model.caption)), .timeStamp(viewModel: DateTimeCollectionViewModel(date: DateFormatter.formatter.date(from: model.date) ?? Date()))]
            
            self.viewModels.append(postData)
           
            completion(true)
        
        
        
       
        }
        
       
    }
   
}
extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, PosterCollectionViewCellDelegate, PostCollectionViewCellDelegate, ActionsCollectionViewCellDelegate, LikesCollectionViewCellDelegate,CaptionsCollectionViewCellDelegate{
   
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModels.count
    }
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return viewModels[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let celltype = viewModels[indexPath.section][indexPath.row]
        
        switch celltype{
            
        case.poster(let poster):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
            
            cell.configure(with: poster, index: indexPath.section)
            
            cell.delegate = self
            
        
            
            return cell
        case.post(let post):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
            
            cell.configure(with: post, index: indexPath.section)
            cell.delegate = self

            
            cell.contentView.backgroundColor = [UIColor.yellow,UIColor.blue,UIColor.cyan ].randomElement()
            return cell
            
        case.actions(let actions):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionsCollectionViewCell.identifier, for: indexPath) as! ActionsCollectionViewCell
            
            cell.configure(with: actions, index: indexPath.section)
            
            cell.delegate = self



         
            return cell
            
        case.likes(let likes):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesCollectionViewCell.identifier, for: indexPath) as! LikesCollectionViewCell
            
            cell.configure(with: likes, index: indexPath.section)
            
            cell.delegate = self

          
            return cell
        case.caption(let caption):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaptionsCollectionViewCell.identifier, for: indexPath) as! CaptionsCollectionViewCell
            
            cell.configure(with: caption)
            
            cell.delegate = self

          
            return cell
            
        case.timeStamp(let timeStamp):
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeStampCollectionViewCell.identifier, for: indexPath) as! TimeStampCollectionViewCell
            
            cell.configure(with: timeStamp)


            
            return cell
        }
        
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
       
        
        guard kind == UICollectionView.elementKindSectionHeader, let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeViewCollectionReusableView.identifier, for: indexPath) as? HomeViewCollectionReusableView else {return UICollectionReusableView()}
         
        
        
            return view
        
    }
    
    //MARK: - Poster Delegate Functions
    
    func posterCollectionViewCellDidtapMore(_ cell: PosterCollectionViewCell, index: Int) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction(title: "Share", style: .default) { [weak self]_ in
           
             let section = self?.viewModels[index] ?? []
            
            section.forEach { celltype in
                switch celltype{
                case.post(let post):
                    
                    DispatchQueue.main.async {
                        
                        let vc = UIActivityViewController(activityItems: ["Post", post.post], applicationActivities: [])
                        
                        self?.present(vc, animated: true, completion: nil)
                    }
                case .poster(viewModel: _):
                    break
                case .actions(viewModel: _):
                    break
                case .likes(viewModel: _):
                    break
                case .caption(viewModel: _):
                    break
                case .timeStamp(viewModel: _):
                    break
                }
            }
            
            
            
            
            
        }
        let link = UIAlertAction(title: "Link", style: .default, handler: nil)
        let report = UIAlertAction(title: "Report", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(share)
        sheet.addAction(link)
        sheet.addAction(report)
        sheet.addAction(cancel)
        
        present(sheet, animated: true, completion: nil)



        

    }
    
    private func sortData(){
        
        allPost = allPost.sorted(by: {first, second in
            
            let date1 = first.post.date
            let date2 = second.post.date
            
            return date1 > date2
        })
        
        viewModels = viewModels.sorted(by:{first, second in
            
            var time1 : Date?
            var time2 : Date?
            
            first.forEach { type in
                switch type{
                case.timeStamp(let stamp):
                    time1 = stamp.date
                default:
                    break
                }}
            second.forEach { type in
                switch type{
                case.timeStamp(let stamp):
                    time2 = stamp.date
                default:
                    break
                }}
            
            
            return time1 ?? Date() > time2 ?? Date()
        })
        
    }
    
    func didTapUsername(_ cell: PosterCollectionViewCell) {
        
        navigationController?.pushViewController(ProfileViewController(user: User(username: "Ben Baller", email: "Ben@gmail.com") ), animated: true)
        
        print("hi")
    }
    //MARK: - Post Delegate Functions

    func didTapLike(_ cell: PostCollectionViewCell, index: Int) {
        
    
        let postID = allPost[index].post.id
        let postName = allPost[index].user.username
        
        DatabaseManager.shared.like(postID: postID, owner: postName) { success in
            if success{
                print("yayy")
            }
        }
        
        HapticsViewController.shared.selectionVibration()
        
    }
    
    //MARK: - Actions Cell functions
     func didTapLikeButton(_ cell: ActionsCollectionViewCell, isLiked: Bool, index: Int) {
         HapticsViewController.shared.selectionVibration()

         
         let postID = allPost[index].post.id
         let postName = allPost[index].user.username
         
         if !isLiked{
             DatabaseManager.shared.like(postID: postID, owner: postName) { success in
                 if success{
                     print("yayy")
                 }
             }
             
         } else{
             
             DatabaseManager.shared.unlike(postID:postID, owner: postName) { success in
                 if success{
                     print("unliked")
                 }
             }
         }
         
         
         
         
     }
     
     func didTapCommentButton(_ cell: ActionsCollectionViewCell, index: Int) {
         HapticsViewController.shared.selectionVibration()

         allPosts()
         
         let vc = PostViewController(post: allPost[index].post, owner: allPost[index].user.username)
         vc.title = "Comments"
         
             self.navigationController?.pushViewController(vc, animated: true)
         
     }
     
     func didTapShareButton(_ cell: ActionsCollectionViewCell, index: Int) {
         HapticsViewController.shared.selectionVibration()

         
         let section = viewModels[index]
         
         section.forEach { celltype in
             switch celltype{
             case.post(let post):
                 
                 let vc = UIActivityViewController(activityItems: ["Post", post.post], applicationActivities: [])
                 
                 present(vc, animated: true, completion: nil)
                 
             case .poster(viewModel: _):
                 break
             case .actions(viewModel: _):
                 break
             case .likes(viewModel: _):
                 break
             case .caption(viewModel: _):
                 break
             case .timeStamp(viewModel: _):
                 break
             }
         }
         
       
     }
     
    //MARK: - Likes Cell Functions
    
    func didTapLikes(_ cell: LikesCollectionViewCell, index: Int) {
        let vc = ListViewController(usernames: allPost[index].post.likers)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - Captions Cell Functions
    func didTapCaptions(_ cell: CaptionsCollectionViewCell) {
        
    }
    
    //MARK: - Configure Collection View
    
    private func configureCollectionView(){
        let sectionHeight = 240 + view.width
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ in
            // items go into groups, groups go into sections, return sections.
        
            
            let poster = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)))
            
            let post = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
            
            let actions = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)))
            
            let likes = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)))
            
            let captions = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)))
            
            let timeStamp = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)))
            

            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(sectionHeight)),
                subitems: [poster, post, actions, likes, captions, timeStamp])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
            
            if index == 0{
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.25)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                
                section.boundarySupplementaryItems = [header]
            }
            

            
            return section
            
        }))
        
        
        view.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
                                
        collectionView.register(ActionsCollectionViewCell.self, forCellWithReuseIdentifier: ActionsCollectionViewCell.identifier)
        
        collectionView.register(LikesCollectionViewCell.self, forCellWithReuseIdentifier: LikesCollectionViewCell.identifier)
        
        collectionView.register(CaptionsCollectionViewCell.self, forCellWithReuseIdentifier: CaptionsCollectionViewCell.identifier)
        
        
        collectionView.register(TimeStampCollectionViewCell.self, forCellWithReuseIdentifier: TimeStampCollectionViewCell.identifier)
        
        collectionView.register(HomeViewCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeViewCollectionReusableView.identifier)
        
        self.collectionView = collectionView
        
    }
}



