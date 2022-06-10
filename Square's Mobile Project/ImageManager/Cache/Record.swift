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

struct CacheRecord {
    
    var key: String
    var path: URL
    var size: Int
    var accessCount: Int
    var lastAccessed: Date?
    var state: FileState
    
}

// state
// downloading from service
// downloading from persistence
// completed
// failed


enum FileState {
    case progress
    case failed
    case cached     // downloaded data from api service, not yet write to disk
    case persisted  // the file only in the file system (ex: evict from cache)
    
//    func completed() -> Bool {
//        return self == .downloaded || self == .persisted
//    }
}
