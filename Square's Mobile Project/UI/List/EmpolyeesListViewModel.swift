//
//  EmpolyeesListViewModel.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit


public class EmployeeViewModel {
    
    var datasource: [Employee] = []
    var error: Error?
    
    var loader: Load?
    
    public convenience init(result: Result<[Employee], Error>) {
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
    
    public func numberOfEmployees() -> Int {
        return datasource.count
    }
    
    public func uuidOfEmployee(at index: Int) -> String {
        return employeeOfIndex(at: index).uuid
    }
    
    public func nameOfEmployee(at index: Int) -> String {
        
        return employeeOfIndex(at: index).fullName
        
    }
    
    public func teamOfEmployee(at index: Int) -> String {
        
        return employeeOfIndex(at: index).team
    }
    
    public func emailOfEmployee(at index: Int) -> String {
        
        return employeeOfIndex(at: index).emailAddress
    }
    
    public func phoneOfEmployee(at index: Int) -> String {
        
        return employeeOfIndex(at: index).phoneNumber
    }
    
    public func thumbnailImageOfEmployee(at index: Int) -> URL? {
        return URL(string: employeeOfIndex(at: index).photourlSmall)
    }
    
    private func roleTypeOfEmployee(at index: Int) -> EmployeeType {
       
        return employeeOfIndex(at: index).employeeType
        
    }
    
    func colorOfRoleType(at index: Int) -> UIColor {
        
        let type = roleTypeOfEmployee(at: index)
        
        switch type {
        case .fullTime:
            return UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
        case .partTime:
            return UIColor(red: 255/255, green: 229/255, blue: 204/255, alpha: 1)
        case .contractor:
            return .lightGray
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
    
    func hieghtOfRow() -> Float {
        
        return datasource.count == 0 ? 0.0 : 120.0
    }
}
