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
    
}
