//
//  ViewController.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/7/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import UIKit

//class EmptyStateView: UIView {
//
//}

class RootViewController: UIViewController, StoryBoarded {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var viewModel: RootViewModel = RootViewModel()

    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "switch_service"), style: .plain, target: self, action: #selector(switchEndPoints))
        navigationItem.title = "Employee"
        
        self.viewModel.getEmployee()
    
    }
    
    func showLoadingIndicator() {
       
        self.loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc func switchEndPoints() {
        
        let av: UIAlertController = UIAlertController(title: "Choose APIs", message: " Base on API select, you will see different result", preferredStyle: .actionSheet)
        let employeeAction = UIAlertAction(title: "Employee", style: .default) { (action) in
            
            self.viewModel.getEmployee()
            
        }
        
        let malformedAction = UIAlertAction(title: "Malformed", style: .default) { (action) in
            
            self.viewModel.getEmployee(.malformed)
            
        }
        
        let emptyAction = UIAlertAction(title: "Empty", style: .default) { (action) in
            
            
            self.viewModel.getEmployee(.empty)
        }
        
        av.addAction(employeeAction)
        av.addAction(malformedAction)
        av.addAction(emptyAction)
        av.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(av, animated: true, completion: nil)
        
        
    }
    
}
