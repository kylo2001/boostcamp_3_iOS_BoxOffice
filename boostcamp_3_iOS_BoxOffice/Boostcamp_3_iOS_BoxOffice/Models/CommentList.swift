//
//  Comments.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

struct CommentList: Codable {
    let comments: [Comment]
    let movieId: String
    
    enum CodingKeys: String, CodingKey {
        case comments
        case movieId = "movie_id"
    }
}
