//
//  EmptyStateViewModel.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

class EmptyStateViewModel {
    
    var loader: Load?
    
    func tryAgain() {
       
        self.loader?.willStart()
    }

}
