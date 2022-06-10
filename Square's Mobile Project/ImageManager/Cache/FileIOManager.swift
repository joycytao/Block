//
//  CacheUtils.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//
 
//Images, however, should be cached on disk so as to not waste device bandwidth. You may use an open source image caching solution, or write your own caching. Do not rely upon HTTP caching for image caching.

import Foundation
import UIKit

struct FileIOManager {
    
    static func documentDirectory() throws -> URL  {
        
        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    static func fileURL(_ url: URL, documentName: String) throws -> String {
        
        return try documentDirectory().appendingPathComponent(String(format: "images/%@.%@", documentName, url.pathExtension)).path
    }
    
    static func write( _ image: UIImage, toDocumentNamed documentName: String, encodedUsing encoder: JSONEncoder = .init() ) throws {
       
        let root = try documentDirectory()
        let folder = root.appendingPathComponent("images/")
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil )
        
        let fileURL = URL(fileURLWithPath: folder.appendingPathComponent(documentName).absoluteString)
                
        if let data = image.jpegData(compressionQuality: 1) {
            try data.write(to: fileURL)
        }
    }
}
