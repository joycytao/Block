//
//  Protocols.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation


protocol Load {
    
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
