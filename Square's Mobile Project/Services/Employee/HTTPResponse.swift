//
//  EmployeeResponse.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/7/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
 
/// (Data?, URLResponse?, Error?) -> HTTPResponse<T:Codable>
public struct HTTPResponse<T: Codable> {
    let value: T? 
    let response: HTTPURLResponse?
    let error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) throws {
        self.value = try data.map { try JSONDecoder().decode(T.self, from: $0) }
        self.response = response as? HTTPURLResponse
        self.error = error
    }
}
