//
//  EmptyStateView.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit

class EmptyStateView: UIViewController, StoryBoarded {
    
    @IBOutlet weak var tryButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var viewModel = EmptyStateViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func endRefresh() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    
    @IBAction func getEmployee() {
        
        self.loadingIndicator.startAnimating()
       
        viewModel.tryAgain()
    }
    
}
