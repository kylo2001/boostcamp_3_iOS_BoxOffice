//
//  UITabBarController + .swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 15/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

extension UITabBarController {
    var firstTab: UINavigationController? {
        let destination = self.viewControllers?[0] as? UINavigationController
        return destination
    }
    
    var secondTab: UINavigationController? {
        let destination = self.viewControllers?[1] as? UINavigationController
        return destination
    }
}



