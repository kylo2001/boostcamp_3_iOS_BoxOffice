//
//  Data+.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 09/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

extension Double {
    var date: String {
        let date = NSDate(timeIntervalSince1970: self)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}
