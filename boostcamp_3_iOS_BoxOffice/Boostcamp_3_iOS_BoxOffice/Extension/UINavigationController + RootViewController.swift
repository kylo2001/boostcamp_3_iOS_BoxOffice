//
//  UINavigationController + RootViewController.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 15/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

extension UINavigationController {
    var rootViewController: UIViewController {
        return self.viewControllers[0]
    }
}
