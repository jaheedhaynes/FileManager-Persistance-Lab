//
//  CollectionViewCell.swift
//  FileManager-Persistance-Lab
//
//  Created by Jaheed Haynes on 1/23/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit
import ImageKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagesImageView: UIImageView!
    
    var image = Image?.self
    
    var mainImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        return imgV
    }()
    
    func configureCell(for image: Image) {
        
        imagesImageView.getImage(with: image.largeImageURL ?? "") { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.imagesImageView.image = UIImage(systemName: "photo.fill.on.rectangle.fill")
                }
            case .success( let image):
                DispatchQueue.main.async {
                    self?.imagesImageView.image = image
                }
                
            }
        }
        
    }
    
    
    
}
