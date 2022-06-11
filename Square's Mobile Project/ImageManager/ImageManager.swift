//
//  ImageManager.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    
    let downloader = HTTPClient(session: .shared)
    private let cache = Cache(with: CacheConfig.default)
    
    var records: [CacheRecord] = []
    
    init() {}
    
    func purgeCahce() {
        cache.removeAllImages()
    }
    
    /// Image download logics work with cache and file system
    ///  1. Check if the image in cache, load from cache if it exist, otherwise move to 2.
    ///     1.a. Check if the image is in file system; if not, force to write to file system
    ///
    ///  2. Check if the image in file system, load from file system amd add file to cache for future use; otherwise, move to 3
    ///     - if cachereord exist and the state == persisted, update the state == cache
    ///     - if cecherecord does not exist, create a new one with state == cache
    ///
    ///  3. Fetch the cacherecord by id, if cacherecord exists and state == progress, show placeholder image; if not move to 4
    ///  4. Download image data from url,  create a new cacherecord with state == progress
    ///     - if success:
    ///         - add to cache
    ///         - write to disk
    ///         - update the cacherecord with state == cache
    ///     - if failed :
    ///         - remove the cacherecord
    ///         - show placehoolder
    func getImage(_ url: URL?, uuid: String, callbackQueue: CallbackQueue = .main, completion: @escaping (Result<UIImage, Error>)->()) {
                
        guard let url = url else {
            // placeholder
            completion(.success(UIImage(named: "thumbnail_placeholder")!))
            return
        }
        
        if let image = cache.image(for: url) {
            print("found in cahce")
            
            // file exist in cache
            completion(.success(image))
            
            
            try? FileIOManager.write(image, toDocumentNamed: String(format: "/images/%@.%@", uuid, url.pathExtension))
            
            return
        }
        
        if uuid.count == 0 {
            completion(.success(UIImage(named: "thumbnail_placeholder")!))
            return
        }
        
        guard let filePath = try? FileIOManager.fileURL(url, documentName: uuid) else {
            completion(.success(UIImage(named: "thumbnail_placeholder")!))
            return
        }
        
        if FileManager.default.fileExists(atPath: filePath) {
            // image exist in file system
            print("found in filesyste: \(filePath)")
            
            if let imageData = try? Data(contentsOf: URL(fileURLWithPath: filePath)), let image = UIImage(data: imageData) {                
                
                // insert file to cache for future use
                cache.insertImage(image, for: url)
                
                if var r = record(for: url.absoluteString) {
                    
                    // update the record
                    if r.state == .persisted {
                                                
                        r.state = .cached
                        r.accessCount += 1
                        r.lastAccessed = Date()
                    }
                    
                } else {
                    // create the record
                    
                    let r = CacheRecord(key: url.absoluteString, path: URL(fileURLWithPath: filePath), size: imageData.count, accessCount: 1, lastAccessed: Date(), state: .cached)
                    
                    records.append(r)
                }
                
                completion(.success(image))

            }
            
            return
        }
        
        if let r = record(for: url.absoluteString), r.state == .progress {
            // show placeholder
            completion(.success(UIImage(named: "thumbnail_placeholder")!))
            
        }
        
        downloader.donwnload(url, callbackQueue: callbackQueue) { [weak self] result in

            guard let wself = self else { return }
            
            let r = CacheRecord(key: url.absoluteString, path: URL(fileURLWithPath: filePath), size: 0, accessCount: 0, lastAccessed: nil, state: .progress)
            wself.records.append(r)
            
            
            switch result {
            case .success(let image):
                
                wself.cache.insertImage(image, for: url)
                wself.updateRecord(url.absoluteString, state: .cached)
                wself.writeToDisk(filePath, image: image)
                callbackQueue.execute {
                    completion(.success(image))
                }
                
            case .failure(let error):
                
                callbackQueue.execute {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func writeToDisk(_ filePath: String, image: UIImage) {
       
        guard let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        if !FileManager.default.fileExists(atPath: filePath) {
            
            do {
                
                let root = try FileIOManager.documentDirectory()
                let folder = root.appendingPathComponent("images", isDirectory: true)
                try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: [:])
                
               try data.write(to: URL(fileURLWithPath: filePath), options: .atomicWrite)
               
           } catch let error as NSError {
               print(error)
           }
        }
    }
    
    private func directoryOfFilePath(_ filePath: String) -> String {
        
        var compoments = filePath.split(separator: "/");
        compoments.removeLast()
        
        return compoments.joined(separator: "/") + "/"
    }
    
}

extension ImageManager: CacheRecordable {
   
    func record(for key: String) -> CacheRecord? {
        
        return records.filter { $0.key == key }.first
    }
    
    func record(for key: String, state: FileState) -> CacheRecord? {
        
        return records.filter { $0.key == key && $0.state == state}.first
    }
    
    func updateRecord(_ key: String, state: FileState) {
        
        if var r = record(for: key) {
            switch state {
            case .cached:
                r.state = .cached
                r.accessCount += 1
                r.lastAccessed = Date()
            default:
                r.state = state
            }
        }
        
    }
    
    func removeRecord(for key: String) {
        records = records.filter { $0.key != key }
    }
    
}

