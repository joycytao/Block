//
//  RootViewModel.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation


class RootViewModel {
    
    var loader: Load?
    var datasource: [Employee] = []
    
    func getEmployee() {
        
        loader?.didStart()
        
        let client = HTTPClient(session: .shared)
        let request = EmployeeRequest<EmployeeResponse>()
        DispatchQueue.global(qos: .userInitiated).async {
            client.send(request) { [weak self] res in
                
                guard let wself = self else { return }
                
                DispatchQueue.main.async {
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
        
        
    }
    
    
        
}
