//
//  EmployeeListCell.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ClickableLabel: UILabel {
    
    var onClick: () -> Void = {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onClick()
    }
    
    
}

class EmployeeListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var emailLabel: ClickableLabel!
    @IBOutlet weak var phoneLabel: ClickableLabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var profileThumbnail: UIImageView!
}
