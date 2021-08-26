//
//  PostViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-31.
//

import UIKit

class PostViewController: UIViewController, CommentBarDelegate, UITextFieldDelegate {
   

    private var post : Post
    private var owner: String
    private var commentHeight: Int?
    
    private var keyboardHeight : CGFloat = 0
    
    
    private var collectionView : UICollectionView?
    private var viewModels = [SinglePostType]()
    private let commentView = CommentBar()
    
    init(post: Post, owner: String) {
        self.post = post
        self.owner = owner
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
           
            configureCollectionView()
            view.addSubview(commentView)
            commentView.textField.delegate = self
            fetchPost()
            commentView.delegate = self
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
            
            
                
            }

         
        
        
        
        override func viewDidLayoutSubviews() {
            collectionView?.frame = view.bounds
            commentView.frame = CGRect(x: 0, y: view.height-view.safeAreaInsets.bottom-70, width: view.width, height: 70)
        }
        
    private func fetchPost(){
        
        guard let user = UserDefaults.standard.string(forKey: "username") else {return}

        
        
        
        
        
        DatabaseManager.shared.aquirePostID(username: user, post: post.id ) { result in
            guard let result = result else {
                return
            }
            
            self.createViewModel(model: result, username: user) {[weak self] success in
                
                if success{
                    
                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
                    }
                }
            }
            
            
 
        }
        
       
    }
    
    private func createViewModel(model: Post, username: String, completion: @escaping ((Bool)->Void)){
        
        guard let postPicture = URL(string: model.postDownloadURL) else {return}
        
        
        
        StorageManager.shared.downloadPicURL(for: username) { url in
            
            guard let profilePicture = url else{return}
            guard let currentUser = UserDefaults.standard.string(forKey: "username") else {return}

        
            DatabaseManager.shared.getComments(for: self.post.id, user: self.owner) { [weak self] comments in
                self?.commentHeight = comments.count
                
                let isLiked = model.likers.contains(currentUser)

                
                var postData : [SinglePostType] = [.poster(viewModel: PosterCollectionViewModel(image: profilePicture , username: username)), .post(viewModel: PostCollectionViewModel(post: postPicture)), .actions(viewModel: ActionsViewModel(isLiked: isLiked)),.likes(viewModel: LikesViewModel(likedBy: ["SeunO"])), .caption(viewModel: CaptionCollectionViewModel(username: username, caption: model.caption))]
                
                comments.forEach { comment in
                    postData.append(.comments(viewModel: comment))
                }
                
                postData.append(.timeStamp(viewModel: DateTimeCollectionViewModel(date: DateFormatter.formatter.date(from: model.date) ?? Date())))
                
                
                
                self?.viewModels.append(contentsOf: postData)
               
                completion(true)
                
            }
       
        }
        
        
        
        
        
        
       
    }
}
extension PostViewController:UICollectionViewDelegate, UICollectionViewDataSource, PosterCollectionViewCellDelegate, PostCollectionViewCellDelegate, ActionsCollectionViewCellDelegate, LikesCollectionViewCellDelegate,CaptionsCollectionViewCellDelegate{
  
    
    
       
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return viewModels.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let celltype = viewModels[indexPath.row]
            
            switch celltype{
                
            case.poster(let poster):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
                
                cell.configure(with: poster, index: indexPath.section)
                
                cell.delegate = self
                
            
                
                return cell
            case.post(let post):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
                
                cell.configure(with: post, index: indexPath.row)
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
                
            case .comments(viewModel: let viewModel):
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentsCollectionViewCell.identifier, for: indexPath) as! CommentsCollectionViewCell
                
                
                cell.configure(model: viewModel)
                
                return cell
            }
            
            
           
        }
        
    
        
        //MARK: - Poster Delegate Functions
        
        func posterCollectionViewCellDidtapMore(_ cell: PosterCollectionViewCell, index: Int) {
            
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let share = UIAlertAction(title: "Share", style: .default) { [weak self]_ in
               
                let celltype = self?.viewModels[index]
    
                    switch celltype{
                    case.post(let post):
                        
                        DispatchQueue.main.async {
                            
                            let vc = UIActivityViewController(activityItems: ["Post", post.post], applicationActivities: [])
                            
                            self?.present(vc, animated: true, completion: nil)
                        }
                    default:
                        break

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
        
        func didTapUsername(_ cell: PosterCollectionViewCell) {
            
            navigationController?.pushViewController(ProfileViewController(user: User(username: "Ben Baller", email: "Ben@gmail.com") ), animated: true)
            
            print("hi")
        }
        //MARK: - Post Delegate Functions

    func didTapLike(_ cell: PostCollectionViewCell, index: Int) {
        
        DatabaseManager.shared.like(postID: post.id, owner:self.owner) { success in
            if success{
                print("yayy")
            }
        }
        
        }
        
        //MARK: - Actions Cell functions
         func didTapLikeButton(_ cell: ActionsCollectionViewCell, isLiked: Bool, index: Int) {
             
             
             
             if !isLiked{
                 DatabaseManager.shared.like(postID: post.id, owner: self.owner) { success in
                     if success{
                         print("yayy")
                     }
                 }
                 
             } else{
                 
                 DatabaseManager.shared.unlike(postID: post.id, owner: self.owner) { success in
                     if success{
                         print("unliked")
                     }
                 }
             }
             
             
         }
         
         func didTapCommentButton(_ cell: ActionsCollectionViewCell, index: Int) {
             
             commentView.textField.becomeFirstResponder()
             commentView.frame = CGRect(x: 0, y: view.height-view.safeAreaInsets.bottom-keyboardHeight, width: view.width, height: 70)
             
         }
         
         func didTapShareButton(_ cell: ActionsCollectionViewCell, index: Int) {
             
             let section = viewModels[index]
             
             
                 switch section{
                 case.post(let post):
                     
                     let vc = UIActivityViewController(activityItems: ["Post", post.post], applicationActivities: [])
                     
                     present(vc, animated: true, completion: nil)
                     
                 default :
                     break
                 }
             
           
         }
         
        //MARK: - Likes Cell Functions
        
    func didTapLikes(_ cell: LikesCollectionViewCell, index: Int) {
            
        let vc = ListViewController(usernames: post.likers)
            
            navigationController?.pushViewController(vc, animated: true)
        }
        //MARK: - Captions Cell Functions
        func didTapCaptions(_ cell: CaptionsCollectionViewCell) {
            
        }
        
        //MARK: - Configure Collection View
        
        private func configureCollectionView(){
            let sectionHeight = 360 + view.width
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ in
                // items go into groups, groups go into sections, return sections.
            
                
                let poster = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)))
                
                let post = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
                
                let actions = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)))
                
                let likes = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)))
                
                let captions = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)))
                
                let timeStamp = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30)))
                
                let comments = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30 * CGFloat(self.commentHeight ?? 1))))

                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(sectionHeight)),
                    subitems: [poster, post, actions, likes, captions,comments, timeStamp])
                
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
            
            
            collectionView.register(CommentsCollectionViewCell.self, forCellWithReuseIdentifier: CommentsCollectionViewCell.identifier)
            
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
            
            self.collectionView = collectionView
            
        }
        
        //MARK: - CommentBar Delegate Functions
        
        func didTapPost(commentBar: CommentBar, text: String) {
            
        print("Hi")
        commentView.textField.resignFirstResponder()
        commentView.textField.text = ""
            
            guard let username = UserDefaults.standard.string(forKey: "username") else {return
            }
                    let model = CommentsModel(username: username, comment: text, dateString: Date().makeDate(date: Date()) ?? "")
            
                    DatabaseManager.shared.addComments(postID: self.post.id, comment: model , commentedUser: self.owner) { success in
                        
                        if success{
                            print("yay")
                        }
                    }
            
        }
        
        //MARK: - TextField Delegates
       
        @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                keyboardHeight = keyboardRectangle.height
                
                commentView.frame = CGRect(x: 0, y: view.height-view.safeAreaInsets.bottom-keyboardHeight, width: view.width, height: 70)
            }
            
    
        }
        
        @objc func keyboardWillHide(_ notification: Notification) {
                commentView.frame = CGRect(x: 0, y: view.height-view.safeAreaInsets.bottom-70, width: view.width, height: 70)
        }
        
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            commentView.textField.resignFirstResponder()
            commentView.frame = CGRect(x: 0, y: view.height-view.safeAreaInsets.bottom-70, width: view.width, height: 70)
            return true
        }
        
        
        
    }






