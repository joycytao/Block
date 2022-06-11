//
//  Record.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

protocol CacheRecordable {
    
    func record(for key: String) -> CacheRecord?
    func record(for key: String, state: FileState) -> CacheRecord?
    
    func updateRecord(_ key: String, state: FileState)
    func removeRecord(for key: String) 
    
}

/// CacheRecord helps to maintain a structural record of metadata for cached items (access count, timestamps, size, etc).

struct CacheRecord {
    
    /// unique key
    var key: String
    
    /// file location  path in file system
    var path: URL
    
    /// evict cache based on the size. e.x. if file size exceed the allowable size 
    var size: Int

    /// accessCount will increase by one when accessing  the file
    var accessCount: Int
    
    /// lastAccessed will update with current time when accessing the file
    var lastAccessed: Date?
    
    /// if the state == .cached, file exists in both cache and file system
    /// if the state == .persisted, file exists in file system only
    /// if the state == .progress, file doesn't exist in neither file sytem or cache
    var state: FileState
    
}


enum FileState {
    case progress   // dowoading, show placholder image when state == progress
    case cached     // downloaded data from api service, not yet write to disk
    case persisted  // the file only in the file system (ex: evict from cache)
}
