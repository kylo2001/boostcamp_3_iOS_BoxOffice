//
//  Movies.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

//{
//    "order_type": 1,
//    "movies": [ Movie ]
//}

struct Movies: Codable {
    let orderType: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case orderType = "order_type"
        case movies
    }
}
