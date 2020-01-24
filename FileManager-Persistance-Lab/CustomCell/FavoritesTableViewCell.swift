//
//  FavoritesTableViewCell.swift
//  FileManager-Persistance-Lab
//
//  Created by Jaheed Haynes on 1/23/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoritedImageView: UIImageView!
    
    var favoritedImage = Image?.self
    
    func configureCell(for favoriteImage: Image) {
        
        favoritedImageView.getImage(with: favoriteImage.largeImageURL ?? "GEORGE-BUTTON") { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.favoritedImageView.image = UIImage(systemName: "GEORGE-BUTTON")
                }
                
            case .success(let image):
                DispatchQueue.main.async {
                    self?.favoritedImageView.image = image
                }
            }
        }
    }
    
}
