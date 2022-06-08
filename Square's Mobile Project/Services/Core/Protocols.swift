//
//  Request.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/7/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET
    case POST
    case DEL
}

public enum ContentType: String {
    
    case json = "application/json"
    case urlForm = "application/x-www-form-urlencoded; charset=utf-8"
}

// MARK: - Protocol-Based Request
public protocol Request {

    associatedtype Response: Decodable

    var url: URL { get }
    var method: HTTPMethod { get }
    var contentType: ContentType { get }

    var decisions: [Workflow] { get }
}

public extension Request {
    
    func buildRequest() throws -> URLRequest  {
        let request = URLRequest(url: url)
        return request
    }
}

public protocol Workflow {
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool
    func apply<Req: Request>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (WorkflowAction<Req>) -> Void)
}

public enum WorkflowAction<Req: Request> {
    case continueWith(Data, HTTPURLResponse)
    case restartWith([Workflow])
    case errored(Error)
    case done(Req.Response)
}


// Some convenient struct example
//
//struct RequestModel: Codable {
//
//}
//struct POSTRequest<T: Codable>: Request  {
//
//    typealias Response = EmployeeResult
//    let url = URL(string: "")!
//    let method = HTTPMethod.POST
//    let contentType = ContentType.json
//
//    var decisions: [Decision] { return [
//
//        ]
//    }
//    var body: T
//}
//
//let request = POSTRequest(body: RequestModel())
