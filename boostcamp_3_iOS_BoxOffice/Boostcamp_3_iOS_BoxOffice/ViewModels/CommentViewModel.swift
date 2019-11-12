//
//  CommentViewModel.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by DongWhan on 2019/11/12.
//  Copyright © 2019 Kim DongHwan. All rights reserved.
//

import Foundation

struct CommentViewModel {
    let writer: String
    let rating: Double
    let contents: String
    let timestamp: Double
    let movieId: String
    let id: String
    
    init(comment: Comment) {
        self.writer = comment.writer
        self.rating = comment.rating
        self.contents = comment.contents
        self.timestamp = comment.timestamp
        self.movieId = comment.movieId
        self.id = comment.id
    }
}
