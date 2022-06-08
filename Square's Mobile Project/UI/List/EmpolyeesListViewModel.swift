//
//  EmpolyeesListViewModel.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit


class EmployeeViewModel {
    
    var datasource: [Employee] = []
    var error: Error?
    
    var loader: Load?
    
    convenience init(result: Result<[Employee], Error>) {
        self.init()
        
        switch result {
        case .success(let employees):
            self.datasource = employees
        case .failure(_):
            self.datasource = []
        }
    }
    
    func refresh() {
        
        self.loader?.willStart()
    }
    
    private func employeeOfIndex(at index: Int) -> Employee {
        
        return self.datasource[index]
    }
    
    func numberOfEmployees() -> Int {
        return datasource.count
    }
    
    func nameOfEmployee(at index: Int) -> String {
        
        return employeeOfIndex(at: index).fullName
        
    }
    
    func teamOfEmployee(at index: Int) -> String {
        
        return employeeOfIndex(at: index).team
    }
    
    func emailOfEmployee(at index: Int) -> String {
        
        return employeeOfIndex(at: index).emailAddress
    }
    
    func phoneOfEmployee(at index: Int) -> String {
        
        return employeeOfIndex(at: index).phoneNumber
    }
    
    private func roleTypeOfEmployee(at index: Int) -> EmployeeType {
       
        return employeeOfIndex(at: index).employeeType
        
    }
    
    func colorOfRoleType(at index: Int) -> UIColor {
        
        let type = roleTypeOfEmployee(at: index)
        
        switch type {
        case .fullTime:
            return .green
        case .partTime:
            return .yellow
        case .contractor:
            return .gray
        }
    }
    
    func textOfRoleType(at index: Int) -> String {
        
        let type = roleTypeOfEmployee(at: index)

        
        switch type {
        case .fullTime:
            return "FT"
        case .partTime:
            return "PT"
        case .contractor:
            return "C"
        }
    }
}
