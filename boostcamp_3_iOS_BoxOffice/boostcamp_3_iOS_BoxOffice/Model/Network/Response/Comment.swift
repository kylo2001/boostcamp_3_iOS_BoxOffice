//
//  Comment.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation
//    "writer": "ref",
//    "rating": 10,
//    "contents": "Dodd’s",
//    "timestamp": 1544187175,
//    "movie_id": "5a54c286e8a71d136fb5378e",
//    "id": "5c0a6d271b865e27d25c590b"

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
