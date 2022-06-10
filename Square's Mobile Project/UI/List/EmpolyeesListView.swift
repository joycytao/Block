//
//  EmpolyeesListView.swift
//  Square's Mobile Project
//
//  Created by CHIEH-YU TAO on 6/8/22.
//  Copyright © 2022 CHIEH-YU TAO. All rights reserved.
//

import Foundation
import UIKit

class EmployeesListView: UITableViewController, StoryBoarded {
    
    var viewModel: EmployeeViewModel?
   
    var refresher: UIRefreshControl = UIRefreshControl()
    
    deinit {
        ImageManager.shared.purgeCahce()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        refresher.addTarget(self, action: #selector(refreshEmployeeData), for: .valueChanged)
        refresher.attributedTitle = NSAttributedString(string: "Refreshing Employee Data")
        
        self.tableView.refreshControl = refresher
        self.tableView.reloadData()
        
    }
    
    @objc private func refreshEmployeeData() {
        self.viewModel?.refresh()
    }
    
    func endRefresh() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.refresher.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.datasource.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: EmployeeListCell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCellIdentifier") as! EmployeeListCell
        
        cell.nameLabel.text = viewModel?.nameOfEmployee(at: indexPath.row) ?? ""
        cell.teamLabel.text = viewModel?.teamOfEmployee(at: indexPath.row) ?? ""
        
        
        
        cell.emailLabel.text = viewModel?.emailOfEmployee(at: indexPath.row) ?? ""
        cell.emailLabel.onClick = { [weak self] in
            
            guard let wself = self else { return }
            
            if let email = wself.viewModel?.emailOfEmployee(at: indexPath.row), let url = URL(string: "mailto:\(email)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        }
        
        cell.phoneLabel.text = viewModel?.phoneOfEmployee(at: indexPath.row) ?? ""
        cell.phoneLabel.onClick = { [weak self] in
        
        guard let wself = self else { return }
        
        if let phone = wself.viewModel?.phoneOfEmployee(at: indexPath.row), let url = URL(string: "tel://\(phone)") {
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            }
        }
            
        }
        
       
        cell.typeLabel.backgroundColor = viewModel?.colorOfRoleType(at: indexPath.row) ?? .clear
        cell.typeLabel.text = viewModel?.textOfRoleType(at: indexPath.row) ?? ""
         
        
        ImageManager.shared.getImage(viewModel?.thumbnailImageOfEmployee(at: indexPath.row), uuid: viewModel?.uuidOfEmployee(at: indexPath.row) ?? "") {  result in
            
            switch result {
            case .success(let image):
                cell.profileThumbnail.image = image
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.viewModel?.hieghtOfRow() ?? 0)
    }
}

