//
//  HomeViewCollectionReusableView.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-23.
//

import UIKit


class HomeViewCollectionReusableView: UICollectionReusableView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    
    static let identifier = "HomeViewCollectionReusableView"
    
    private var viewModel : [Story] = []
    
    private let collectionView : UICollectionView = {
        
       let layout =  UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        
    
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout )
        
        view.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        
        
        return view
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = bounds
    }
    
    public func configure(with model: StoryViewModel ){
        self.viewModel = model.stories
        
        
    }
    
    
    //MARK: - cell delegate funcs
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as? StoryCollectionViewCell else {return UICollectionViewCell()}
        
//        let model = viewModel[indexPath.row]
        
        guard let image = UIImage(named: "test") else {return UICollectionViewCell()}
        
        let model = Story(story: image, username: "SeunOlalekan")
        
        
        cell.configure(with: model)
        
        
        return cell
        
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.height, height: collectionView.height)
    }
}
