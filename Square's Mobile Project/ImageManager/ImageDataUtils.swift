//
//  ImageDataUtils.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/9/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

enum ImageContentFormat {
    
    case jpeg
    case png
    case heic
    case unknown
}

extension Data {
    
    var imageContentFormat: ImageContentFormat {
        
        var values = [UInt8](repeating: 0, count: 1)
        self.copyBytes(to: &values, count: 1)
        
        switch (values[0]) {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        default:
            return .png
        }
    }
}
