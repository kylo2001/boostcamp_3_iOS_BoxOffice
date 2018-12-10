//
//  String+.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 10/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

extension String {
    /** 숫자형 문자열에 3자리수 마다 콤마 넣기 Double형으로 형변환 되지 않으면 원본을 유지한다.
     ```
     swift let stringValue = "10005000.123456789"
     print(stringValue.insertComma)
     // 결과 : "10,005,000.123456789"
     ```
     */
    
    var insertComma: String {
        let numberFormatter = NumberFormatter(); numberFormatter.numberStyle = .decimal
        // 소수점이 있는 경우 처리
        if let _ = self.range(of: ".") {
            var numberArray = self.components(separatedBy: ".")
            if numberArray.count == 1 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                guard let doubleValue = Double(numberString) else {
                    return self
                }
                return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
            } else if numberArray.count == 2 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                guard let doubleValue = Double(numberString) else {
                    return self
                }
                return (numberFormatter.string(from: NSNumber(value: doubleValue)) ?? numberString) + ".\(numberArray[1])"
            }
        } else {
            guard let doubleValue = Double(self) else {
                return self
            }
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        return self
    }
}
