//
//  AppCooridnator.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit

class AppCooridnator: BaseCoordinator {
    
    lazy var rootViewController: RootViewController = {
        return RootViewController.instantiate()
    }()
    
    lazy var listView: EmployeesListView = {
        return  EmployeesListView.instantiate()
    }()
    
    lazy var emptyStateView: EmptyStateView = {
        return  EmptyStateView.instantiate()
    }()
    
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        
        guard let window = window else {
            return
        }
                
        window.rootViewController = UINavigationController(rootViewController: rootViewController)
        window.makeKeyAndVisible()
        
        rootViewController.viewModel.loader = self
        
    }
}

extension AppCooridnator: ResultSwitchable {
    
    func showList(with result: Result<[Employee], Error>) {
        
        listView.viewModel = EmployeeViewModel(result: result)
        listView.viewModel?.loader = self
        
        self.rootViewController.remove(emptyStateView)
        self.rootViewController.add(listView)
        
        listView.endRefresh()
        
    }
    
    func showEmptyState() {
        
        emptyStateView.viewModel.loader = self
        
        self.rootViewController.remove(listView)
        self.rootViewController.add(emptyStateView)
        
        emptyStateView.endRefresh()
    }
    
    
}
    
extension AppCooridnator: Load {
    
    func willStart() {
        
        self.rootViewController.viewModel.getEmployee()
    }
    
    func didFinish(with result: [Employee]) {
        
        self.rootViewController.hideLoadingIndicator()
        
        if result.count == 0 {
            showEmptyState()
        } else {
            showList(with: Result<[Employee], Error>.success(result))
        }
    }
    
    func didStart() {
        self.rootViewController.showLoadingIndicator()
    }
    
    func didFail(with error: Error) {
        
        self.rootViewController.hideLoadingIndicator()
        showList(with: Result<[Employee], Error>.failure(error))
    }
    
    
}
