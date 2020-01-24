//
//  PersistanceHelper.swift
//  FileManager-Persistance-Lab
//
//  Created by Jaheed Haynes on 1/23/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import Foundation

enum DataPersistenceError: Error {
    case savingError(Error)
    case fileDoesNotExist(String)
    case noData
    case decodingError(Error)
    case deletingError(Error)
}

class PersistenceHelper {
    
    
    private var images = [Image]()
    
    let filename = "favorites.plist"
    
    public static let shared = PersistenceHelper()
    
    private func save() throws {
        
        // step 1
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        do {
            // step 3
            let data = try PropertyListEncoder().encode(images)
            
            // step 4
            try data.write(to: url, options: .atomic)
        } catch {
            // step 5
            throw DataPersistenceError.savingError(error)
        }
    }
    
    
    public func addToFavorites(item: Image) throws {
        // step 2
        images.append(item)
        
        do {
            try save()
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    
    
    public func loadImage() throws -> [Image] {
        
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = FileManager.default.contents(atPath: url.path) {
                do {
                    images = try PropertyListDecoder().decode([Image].self, from: data)
                } catch {
                    throw DataPersistenceError.decodingError(error)
                }
            } else {
                throw DataPersistenceError.noData
            }
        }
        else {
            throw DataPersistenceError.fileDoesNotExist(filename)
        }
        return images
    }
    
    
    public func delete(image index: Int) throws {
        
        images.remove(at: index)

        do {
            try save()
        } catch {
            throw DataPersistenceError.deletingError(error)
        }
    }
}
