//
//  ExploreViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class ExploreViewController: UIViewController, UISearchResultsUpdating, SearchResultsViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
 
    private var collectionPosts = [Post]()
    
   
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (index, _) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
            
            let fullItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            
            let tripletItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)))
             
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension:.fractionalHeight(1)), subitem: fullItem, count: 2)
    
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(100)), subitems: [item, verticalGroup])
            
            
            let threeItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(100)), subitem: tripletItem, count: 3)
            
            let bottomVertical = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(200)), subitems: [ horizontalGroup, threeItemGroup])
            
            
            let section = NSCollectionLayoutSection(group: bottomVertical)
            
            return section
        }
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.backgroundColor = .secondarySystemBackground
        
        view.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        
        
        return view
        
    }()
    
   
  let searchController = UISearchController(searchResultsController: SearchResultsViewController())

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Explore"
        (searchController.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchData()
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              let term = searchController.searchBar.text,
        !term.trimmingCharacters(in: .whitespaces).isEmpty else{return}
        

        DatabaseManager.shared.queryUsers(with: term) { result in
            
            resultsVC.update(with: result)
            
            
            
        }
        
    }
    
    //MARK: - Fetch Data Function
    
    private func fetchData(){
        
        DatabaseManager.shared.explorePosts { [weak self] posts in
            
            DispatchQueue.main.async {
                self?.collectionPosts = posts
                self?.collectionView.reloadData()
            }
            
        }
        
    }

    
    
    //MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    //MARK: - Search Results delegate functions
    
    
    func didTapProfile(user: User) {
        navigationController?.pushViewController(ProfileViewController(user: user), animated: true)
    }
    
    //MARK: - CollectionView Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else {return UICollectionViewCell()}
        
        guard let configureURL = URL(string: collectionPosts[indexPath.row].postDownloadURL) else{return UICollectionViewCell()}
        
        cell.configureCell(with:  configureURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let post = collectionPosts[indexPath.row]
        
        let vc = PostViewController(post: post)
        
        navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    

   
}
