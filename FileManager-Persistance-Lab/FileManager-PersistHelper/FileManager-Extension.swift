//
//  FileManager-Extension.swift
//  FileManager-Persistance-Lab
//
//  Created by Jaheed Haynes on 1/23/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func pathToDocumentsDirectory(with filename: String) ->URL {
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
}
