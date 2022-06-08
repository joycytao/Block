//
//  EmployeeRequest.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/7/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

 // EmployeeRequest(url: "URL_GOES_HERE")

struct EmployeeRequest<T: Codable>: Request {
    
    typealias Response = EmployeeResponse
    var url = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json")!
    var method = HTTPMethod.GET
    var contentType = ContentType.json

    // what actions want to execute after receive data
    var decisions: [Workflow] { return [
            ParseResultWorkflow()
        ]
    }
}

struct ParseResultWorkflow: Workflow {
    
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        return true
    }

    func apply<Req: Request>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (WorkflowAction<Req>) -> Void)
    {
        do {
            let value = try JSONDecoder().decode(Req.Response.self, from: data)
            closure(.done(value))
        } catch {
            closure(.errored(ResponseError.dataParsingFailed(data, nil)))
        }
    }
}
