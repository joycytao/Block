//
//  RootViewModel.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

public enum LoadType {
    case employee
    case malformed
    case empty
}


open class RootViewModel: FetchEmployee {
    
    public init() {}
    
    public var loader: Load?
    public var datasource: [Employee] = []
    
    func getEmployee() {
        getEmployee(.employee)
    }
    
        
}
