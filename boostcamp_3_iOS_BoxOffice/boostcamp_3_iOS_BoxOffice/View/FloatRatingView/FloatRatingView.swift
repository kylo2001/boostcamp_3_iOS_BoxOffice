//
//  FloatRatingView.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 09/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class UIFloatRatingView: UIView {
    
    // MARK: Initializations
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        initImageViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initImageViews()
    }
    
    // MARK: Helper methods
    private func initImageViews() {
    }
}
