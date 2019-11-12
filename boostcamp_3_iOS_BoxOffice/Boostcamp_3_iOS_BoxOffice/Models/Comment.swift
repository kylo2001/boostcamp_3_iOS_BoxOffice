//
//  Comment.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let writer: String
    let rating: Double
    let contents: String
    let timestamp: Double
    let movieId: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case movieId = "movie_id"
        case writer, rating, contents, timestamp, id
    }
}
