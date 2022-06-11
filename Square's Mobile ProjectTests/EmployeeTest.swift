//
//  EmployeeAPI.swift
//  Square's Mobile ProjectTests
//
//  Created by CHIEH-YU TAO on 6/10/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import Square_s_Mobile_Project
import XCTest

class EmployeeTestCase: XCTestCase, Load {
   
    var mock: MockViewModel!
    var employeeMock: EmployeeViewModel?
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        self.mock = MockViewModel()
        self.mock.loader = self
    }
    
    func willStart() {}
    func didStart() { }
    func didFail(with error: Error) {
        employeeMock = EmployeeViewModel(result: Result<[Employee], Error>.failure(error))

    }
    func didFinish(with result: [Employee]) {
        
        if result.count > 0 {
            employeeMock = EmployeeViewModel(result: Result<[Employee], Error>.success(result))
            
        }
        if let exp = expectation, exp.description == "Load" {
            exp.fulfill()
        }
        
    }
    
    func testEmployeeList(){
        
        expectation = XCTestExpectation(description: "Load")
        self.mock.getEmployee(.employee)
        
        XCTAssertEqual(3, self.employeeMock?.numberOfEmployees())
        XCTAssertEqual("jmason.demo@squareup.com", self.employeeMock?.emailOfEmployee(at: 0))
        XCTAssertEqual("0d8fcc12-4d0c-425c-8355-390b312b909c", self.employeeMock?.uuidOfEmployee(at: 0))
        XCTAssertEqual("Justine Mason", self.employeeMock?.nameOfEmployee(at: 0))

    }
    
    func testMalformedEmployeeList(){
        
        expectation = XCTestExpectation(description: "Load")
        self.mock.getEmployee(.malformed)
        
        XCTAssertEqual(0, self.employeeMock?.numberOfEmployees())
        
    }
    
    func testEmptyEmployeeList(){
        
        expectation = XCTestExpectation(description: "Load")
        self.mock.getEmployee(.empty)
        
        XCTAssertNil(self.employeeMock)
    }
    
    
}

class MockViewModel: RootViewModel {}

extension FetchEmployee where Self: MockViewModel {
    
    func getEmployee(_ type: LoadType) {
        
        var fileName: String
        switch type {
        case .employee:
            fileName = "employee"
        case .empty:
            fileName = "empty"
        case .malformed:
            fileName = "malformed"
        }
        
        guard let pathURL = LoaderUtils().fetchMockResponse(fileName: fileName) else {
            return
        }
            
        do {
            let jsonData = try Data(contentsOf: pathURL)
            do {
                let value = try JSONDecoder().decode(EmployeeResponse.self, from: jsonData)
                self.loader?.didFinish(with: value.employees)

            } catch {
                self.loader?.didFail(with: error)
            }
        } catch {
            return
        }
    }
}


