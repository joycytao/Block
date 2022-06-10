//
//  RootViewModel.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

enum LoadType {
    case employee
    case malformed
    case empty
}

class RootViewModel {
    
    var loader: Load?
    var datasource: [Employee] = []
    
    func getEmployee(_ type: LoadType = .employee) {
        
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
