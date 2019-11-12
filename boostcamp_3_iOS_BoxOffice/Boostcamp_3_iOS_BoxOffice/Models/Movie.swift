//
//  Movie.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let reservationRate: Double
    var genre: String?
    var director: String?
    let userRating: Double
    var duration: Int?
    let title: String
    let grade: Int
    let reservationGrade: Int
    var synopsis: String?
    var audience: Int?
    var thumb: String?
    let date: String
    let movieId: String
    var actor: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
        case reservationGrade = "reservation_grade"
        case movieId = "id"
        case genre, director, duration, title, grade, synopsis, audience, thumb, date, actor, image
    }
}
