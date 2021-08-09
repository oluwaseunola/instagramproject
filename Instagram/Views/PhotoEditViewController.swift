//
//  PhotoEditViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-26.
//
import CoreImage
import UIKit

class PhotoEditViewController: UIViewController {
    
    private var filterImages = [UIImage]()
    
    private let imageView : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .secondarySystemBackground
        
        return collectionView
        
    }()

    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    var image : UIImage

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        title = "Edit"
        
        view.addSubview(imageView)
        imageView.image = image
        setupFilters()
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
       
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = view.bounds
        
        let size = view.width - 20
        collectionView.frame = CGRect(x: (view.width - size)/2, y: imageView.bottom - 200, width: size, height: 80)
    }
    
    private func setupFilters(){
        
        guard let filteredImage =  UIImage(systemName: "camera.filters") else {return}
        
        filterImages.append(filteredImage)
        
        
        
    }

    private func filter(image: UIImage){
        
        guard let cgImage = image.cgImage else {return}
        
        let filter = CIFilter(name: "CIColorMonochrome")
        
        filter?.setValue(CIImage(cgImage: cgImage), forKey: "inputImage")
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")
        
        guard let outputImage = filter?.outputImage else {return}
        
        let context = CIContext()
        
        guard let outputCGIMage =  context.createCGImage(outputImage, from: outputImage.extent) else {return}
        
        let uiImage = UIImage(cgImage: outputCGIMage)
        
        imageView.image = uiImage
        

    }
    
    @objc func didTapNext(){
        
        if let filteredImage = imageView.image {
            let caption = CaptionViewController(image: filteredImage )
            caption.title = "Add Caption"
            
            navigationController?.pushViewController(caption, animated: true)
            
            
        }
        
      
        
        
    }

    

}

extension PhotoEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return filterImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
        
        let image = filterImages[indexPath.row]
        
        
        cell.configureCell(with: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        filter(image: image)
    
}

}
