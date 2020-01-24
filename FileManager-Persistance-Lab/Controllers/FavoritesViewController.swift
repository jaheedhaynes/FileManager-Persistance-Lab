//
//  FavoritesViewController.swift
//  FileManager-Persistance-Lab
//
//  Created by Jaheed Haynes on 1/23/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var favorites = [Image](){
        didSet {
            DispatchQueue.main.async {
                self.favoritesTableView.reloadData()
                
            }
        }
    }
    
    //-----------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        loadFavoritedImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavoritedImages()
    }
    
    //-----------------------------------------------------------------------------------

    
    
    private func loadFavoritedImages() {
        do {
            try favorites = PersistenceHelper.shared.loadImage()
        } catch {
            showAlert(title: "OK", message: "error loading favorited images")
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let detailVC = segue.destination as? ImageDetailViewController, let indexPath = favoritesTableView.indexPathForSelectedRow else {
            fatalError("can't downcast to ImageDetailViewController ")
        }
        
        let cellInRow = favorites[indexPath.row]
        
        detailVC.imageDetails = cellInRow
        
    }
}


//==================================================================================================
//MARK: EXTENSION (CollectionView Data Source

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let favoriteCell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoritesTableViewCell else {
            
            fatalError("can't downcast to FavoritesTableViewCell")
        }
        
        let favImage = favorites[indexPath.row]
        
        favoriteCell.configureCell(for: favImage)
        
        return favoriteCell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            
        case .insert:
            return
        case .delete:
            try? PersistenceHelper.shared.delete(image: indexPath.row)
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        default:
            showAlert(title: "OK", message: "Error occured when trying to delete")
        }
    }
}



//MARK: EXTENSION (Delegate)

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
}
