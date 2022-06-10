//
//  CacheConfig.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/9/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit


struct CacheConfig {
    
    let maxMemoryCacheSize: Int
    let maxCahceCount: Int
    let maxCacheAge: Int
    
    // default setting: 100mb, expiry date 1 week
    static let `default` = CacheConfig(maxMemoryCacheSize: 1024 * 1024 * 100, maxCahceCount: 100, maxCacheAge: 60 * 60 * 24 * 7)
}


protocol ImageCache {
    
    // return the image assoicate with a url
    func image(for url: URL) -> UIImage?
    func insertImage(_ image: UIImage?, for url: URL)
    func removeImage(for url: URL)
    func removeAllImages()
    
    subscript(_ key: URL) -> UIImage? { get set }
    
}

public final class Cache {
    
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.maxCahceCount
        cache.totalCostLimit = config.maxMemoryCacheSize
        
        return cache
    }()
    
    
    private let lock = NSLock()
    private let config: CacheConfig
    
    
    
    init(with config: CacheConfig) {
        self.config = config
    }
}

extension Cache: ImageCache {
    
    func image(for url: URL) -> UIImage? {
        
        lock.lock(); defer { lock.unlock()}
        
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return image
        }
        
        return nil
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        
        guard let image = image else { return}
        
        lock.lock(); defer { lock.unlock() }
        
        imageCache.setObject(image as AnyObject, forKey: url as AnyObject)
    }
    
    func removeImage(for url: URL) {
        
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
        
    }
    
    func removeAllImages() {
        
        lock.lock(); defer { lock.unlock()}
        imageCache.removeAllObjects()
    }
    
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for:key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }

}
