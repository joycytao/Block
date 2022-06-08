//
//  Common.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/7/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

public enum ResponseError: Error {
    case nilData
    case sessionError(Error)
    case nonHTTPResponse
    case dataParsingFailed(Data, Error?)
    case apiError(error: APIError, statusCode: Int)
}

public struct APIError: Decodable {
    let code: Int
    let reason: String
}
