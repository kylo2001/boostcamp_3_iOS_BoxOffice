//
//  UIView+.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

extension UIView {
    static func instantiateFromXib(xibName: String) -> UIView? {
        return UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }
}
