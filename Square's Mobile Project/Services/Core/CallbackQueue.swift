//
//  CallbackQueue.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit
public enum CallbackQueue {
    
    case main
    case mainAsync
    case untouch
    case addOperation(OperationQueue)
    case dispatch(DispatchQueue)
    
    public func execute(_ block: @escaping () -> Void) {
        
        switch self {
        case .mainAsync:
            DispatchQueue.main.async { block() }
        
        case .main:
            // if it is the main queue and the current thread is main thread, the block will exexute immediately; otherwise, it will being dispatched
            DispatchQueue.main.syncMain { block() }
            
        case .untouch:
            block()
            
        case .dispatch(let queue):
            // dispatch block to a sepcific queue
            queue.async { block() }
            
        case .addOperation(let op):
            // add block to a sepcific operation queue
            op.addOperation { block() }
            
        }
    }
}

extension DispatchQueue {
    
    func syncMain(_ block: @escaping () -> (Void)) {
        
        if self == DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async {
                block()
            }
        }
    }
    
}
