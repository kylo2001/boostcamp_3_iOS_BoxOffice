//
//  String + Capitalize.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 11/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

extension String {
    var capitalizeFirst: String {
        if self.count == 0 {
            return self
        }
        return String(self[self.startIndex]).capitalized + String(self.dropFirst())
    }
}
