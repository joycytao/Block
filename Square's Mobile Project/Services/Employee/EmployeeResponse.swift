//
//  Response.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/7/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation

// Genrate codable object via https://app.quicktype.io

// MARK: - Response
public struct EmployeeResponse: Codable {
    public let employees: [Employee]

    public init(employees: [Employee]) {
        self.employees = employees
    }
}

// MARK: - Employee
public struct Employee: Codable {
    public let uuid, fullName, phoneNumber, emailAddress: String
    public let biography: String
    public let photourlSmall, photourlLarge: String
    public let team: String
    public let employeeType: EmployeeType

    enum CodingKeys: String, CodingKey {
        case uuid
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography
        case photourlSmall = "photo_url_small"
        case photourlLarge = "photo_url_large"
        case team
        case employeeType = "employee_type"
    }

    public init(uuid: String, fullName: String, phoneNumber: String, emailAddress: String, biography: String, photourlSmall: String, photourlLarge: String, team: String, employeeType: EmployeeType) {
        self.uuid = uuid
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.biography = biography
        self.photourlSmall = photourlSmall
        self.photourlLarge = photourlLarge
        self.team = team
        self.employeeType = employeeType
    }
}

public enum EmployeeType: String, Codable {
    case contractor = "CONTRACTOR"
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
}
