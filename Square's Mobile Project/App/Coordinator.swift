//
//  AppCooridnator.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? {get set}
    var children: [Coordinator] { get set }
    
    func start()
    func finish()
}


class BaseCoordinator: Coordinator {
    
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    
    func start() {}
    func finish() {}
    
    func addChildCoordinator(with cooridnator: Coordinator) {
        children.append(cooridnator)
    }
    
    func removeChildCoordinator(with cooridnator: Coordinator) {
        
        for (index, element) in children.enumerated() {
            if element === cooridnator {
                children.remove(at: index)
                break
            }
        }
    }
    
    func removeAllChildrenWith<T>(type: T.Type) {
        children = children.filter { $0 is T == false}
    }
    
    func removeAllChildren() {
        children.removeAll()
    }
}

