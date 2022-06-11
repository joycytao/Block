//
//  LoaderUtils .swift
//  Square's Mobile ProjectTests
//
//  Created by CHIEH-YU TAO on 6/10/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

class LoaderUtils {
    
    func fetchMockResponse(fileName: String) -> URL? {
        
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        return url
        
        
    }
    
}
