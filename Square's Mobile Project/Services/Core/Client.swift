//
//  Client.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/7/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

struct HTTPClient {
    
    let session: URLSession
    init(session: URLSession) {
        self.session = session
    }
    
    func send<Req: Request>(
        _ request: Req,
        decisions: [Workflow]? = nil,
        handler: @escaping (Result<Req.Response, Error>) -> Void)
    {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.buildRequest()
        } catch {
            handler(.failure(error))
            return
        }

        let task = session.dataTask(with: urlRequest) {
            data, response, error in

            guard let data = data else {
                handler(.failure(error ?? ResponseError.nilData))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                handler(.failure(ResponseError.nonHTTPResponse))
                return
            }

            self.handleDecision(
                request,
                data: data,
                response: response,
                decisions: decisions ?? request.decisions,
                handler: handler
            )
        }
        task.resume()
    }
    
    func handleDecision<Req: Request>(
        _ request: Req,
        data: Data,
        response: HTTPURLResponse,
        decisions: [Workflow],
        handler: @escaping (Result<Req.Response, Error>) -> Void)
    {
        guard !decisions.isEmpty else {
            fatalError("No decision left but did not reach a stop.")
        }

        var decisions = decisions
        let current = decisions.removeFirst()

        guard current.shouldApply(request: request, data: data, response: response) else {
            handleDecision(request, data: data, response: response, decisions: decisions, handler: handler)
            return
        }

        current.apply(request: request, data: data, response: response) { action in
            switch action {
            case .continueWith(let data, let response):
                self.handleDecision(
                    request, data: data, response: response, decisions: decisions, handler: handler)
            case .restartWith(let decisions):
                self.send(request, decisions: decisions, handler: handler)
            case .errored(let error):
                handler(.failure(error))
            case .done(let value):
                handler(.success(value))
            }
        }
    }
}