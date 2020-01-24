//
//  ImagesViewController.swift
//  FileManager-Persistance-Lab
//
//  Created by Jaheed Haynes on 1/23/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchQuery = "jamaica" {
        didSet {
            DispatchQueue.main.async {
                self.getImages(with: self.searchQuery)
            }
        }
    }
    
    private var images = [Image](){
        didSet {
            DispatchQueue.main.async {
                self.imagesCollectionView.reloadData()
            }
        }
    }
    
    //-----------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        searchBar.delegate = self
        getImages(with: searchQuery)
    }
    
    //-----------------------------------------------------------------------------------
    
    
    private func getImages(with searchQuery: String) {
        ImagesAPIClient.getImages(with: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("could not load images . Error : \(error)")
            case .success(let images):
                self?.images = images
            }
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? ImageDetailViewController, let index = imagesCollectionView.indexPathsForSelectedItems?.first else {
            fatalError("could not find view controller for segue")
        }
        detailVC.imageDetails = images[index.row]
    }
}

//==================================================================================================
//MARK: EXTENSION (CollectionView Data Source

extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? CollectionViewCell else {
            fatalError("could not downcast to ImagesCollectionViewCell")
        }
        
        let image = images[indexPath.row]
        
        imageCell.configureCell(for: image)
        
        return imageCell
    }
}


//MARK: EXTENSION (Delegate)

extension ImagesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interItemSpacing: CGFloat  = 5 //space between items
        let maxWidth = UIScreen.main.bounds.size.width //maximum screen width
        let numberOfItems: CGFloat = 3 // number of items per row
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        let itemWidth:CGFloat = (maxWidth - totalSpacing) / numberOfItems
        return CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension ImagesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard !(searchBar.text?.isEmpty ?? true) else {
            getImages(with: "")
            return
        }
        searchQuery = searchBar.text ?? "rainbow"
    }
}
