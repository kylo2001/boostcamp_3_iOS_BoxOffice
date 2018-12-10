//
//  UITableViewController+.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 10/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

extension UITableViewController {
    func registerCustomCells(nibNames: [String], forCellReuseIdentifiers: [String]) {
        for (index, element) in nibNames.enumerated() {
            tableView.register(UINib(nibName: element, bundle: nil), forCellReuseIdentifier: forCellReuseIdentifiers[index])
        }
    }
}
