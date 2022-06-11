//
//  Protocols.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation


public protocol Load {
    
    func willStart()
    func didFinish(with result: [Employee])
    func didStart()
    func didFail(with error: Error)
}


protocol ErrorHandler {
    
    func showAlert(with message: String)
}


protocol ResultSwitchable {
    
    func showList(with result: Result<[Employee], Error>)
    func showEmptyState()
}

public protocol FetchEmployee {
    func getEmployee(_ type: LoadType)
}

extension FetchEmployee where Self: RootViewModel {
    
    public func getEmployee(_ type: LoadType) {
        
        loader?.didStart()
        
        let client = HTTPClient(session: .shared)
        
        var request: EmployeeRequest<EmployeeResponse>
        switch type {
        case .employee:
            request = EmployeeRequest<EmployeeResponse>()
        case .empty:
            request = EmployeeRequest<EmployeeResponse>(url: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json")!, method: .GET, contentType: .json)
        case .malformed:
            request = EmployeeRequest<EmployeeResponse>(url: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json")!, method: .GET, contentType: .json)
        }
        
                
        client.send(request) { [weak self] res in
            
            guard let wself = self else { return }
            
            switch res {
            case .success(let value):
                if value.employees.count > 0 {
                    wself.datasource = value.employees
                }
                wself.loader?.didFinish(with: value.employees)
                
            case .failure(let error):
                wself.loader?.didFail(with: error)
            }
        }
    }
}
