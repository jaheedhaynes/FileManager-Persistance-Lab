//
//  ImageDetailViewController.swift
//  FileManager-Persistance-Lab
//
//  Created by Jaheed Haynes on 1/23/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit
import ImageKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var imageDetails: Image!
    
 
    
    var dataPersistence = PersistenceHelper()
    
    //-----------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
    }
    
    //-----------------------------------------------------------------------------------

    
    private func updateUI() {
        
 
        
        imageView.getImage(with: imageDetails.largeImageURL ?? "") { [weak self] (result) in
            
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(systemName: "GEORGE-BUTTON")
                }
                
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
        
        likesLabel.text = "Likes: \(imageDetails.likes?.description ?? "")"
        
        viewsLabel.text = "Views: \(imageDetails.views?.description ?? "")"
    }
    
    //-----------------------------------------------------------------------------------

    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        dismiss(animated: true)
        
        do {
            showAlert(title: "OK", message: "Added to Favorites")
            try PersistenceHelper.shared.addToFavorites(item: imageDetails)
            
        } catch {
            showAlert(title: "OK", message: "Photo could not save")
            print("error saving: \(error)")
        }

    }
    
}
