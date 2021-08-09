//
//  ViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    private var collectionView : UICollectionView?
    private var viewModels = [[HomeViewCellsType]]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .red
       
        configureCollectionView()
        fetchPost()

    }
    
    override func viewDidLayoutSubviews() {
        collectionView?.frame = view.bounds
    }
    
    private func fetchPost(){
        
        guard let user = UserDefaults.standard.string(forKey: "username") else {return}
        
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
                    self?.collectionView?.reloadData()
                }
                
                
                
                
            case.failure(let error):
                print(error)
            }
        }
   
        
       
        collectionView?.reloadData()
    }
    
    private func createViewModel(model: Post, username: String, completion: @escaping ((Bool)->Void)){
        
        

        
        
        StorageManager.shared.downloadPicURL(for: username) { url in
            
            guard let postURL = URL(string: model.postDownloadURL) else{return}

            guard let picURL = url else{return}
            

        
            let postData : [HomeViewCellsType] = [.poster(viewModel: PosterCollectionViewModel(image: picURL , username: username)), .post(viewModel: PostCollectionViewModel(post: postURL)), .actions(viewModel: ActionsViewModel(isLiked: true)),.likes(viewModel: CommentsViewModel(likedBy: ["SeunO"])), .caption(viewModel: CaptionCollectionViewModel(username: username, caption: model.caption)), .timeStamp(viewModel: DateTimeCollectionViewModel(date: DateFormatter.formatter.date(from: model.date) ?? Date()))]
            
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
            
            cell.configure(with: poster)
            
            cell.delegate = self
            
        
            
            return cell
        case.post(let post):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
            
            cell.configure(with: post)
            cell.delegate = self

            
            cell.contentView.backgroundColor = [UIColor.yellow,UIColor.blue,UIColor.cyan ].randomElement()
            return cell
            
        case.actions(let actions):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionsCollectionViewCell.identifier, for: indexPath) as! ActionsCollectionViewCell
            
            
            cell.configure(with: actions)
            
            cell.delegate = self



         
            return cell
            
        case.likes(let likes):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesCollectionViewCell.identifier, for: indexPath) as! LikesCollectionViewCell
            
            cell.configure(with: likes)
            
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
    
    //MARK: - Poster Delegate Functions
    
    func posterCollectionViewCellDidtapMore(_ cell: PosterCollectionViewCell) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction(title: "Share", style: .default, handler: nil)
        let link = UIAlertAction(title: "Link", style: .default, handler: nil)
        let report = UIAlertAction(title: "Report", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(share)
        sheet.addAction(link)
        sheet.addAction(report)
        sheet.addAction(cancel)
        
        present(sheet, animated: true, completion: nil)



        

    }
    
    func didTapUsername(_ cell: PosterCollectionViewCell) {
        
        navigationController?.pushViewController(ProfileViewController(user: User(username: "Ben Baller", email: "Ben@gmail.com") ), animated: true)
        
        print("hi")
    }
    //MARK: - Post Delegate Functions

    func didTapLike(_ cell: PostCollectionViewCell) {
        
    }
    
    //MARK: - Actions Cell functions
     func didTapLikeButton(_ cell: ActionsCollectionViewCell, isLiked: Bool) {
         
     }
     
     func didTapCommentButton(_ cell: ActionsCollectionViewCell) {
//         let vc = PostViewController(post: nil)
//         vc.title = "Comments"
//         
//         navigationController?.pushViewController(vc, animated: true)
     }
     
     func didTapShareButton(_ cell: ActionsCollectionViewCell) {
         let vc = UIActivityViewController(activityItems: ["Ayyee"], applicationActivities: [])
         
         present(vc, animated: true, completion: nil)
     }
     
    //MARK: - Likes Cell Functions
    
    func didTapLikes(_ cell: LikesCollectionViewCell) {
        let vc = ListViewController()
        
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
        
        self.collectionView = collectionView
        
    }
}


