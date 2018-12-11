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
    
    var simpleTableInfo: String {
        return "평점 : " + String(self.userRating) + " 예매순위 : " + String(self.reservationGrade) + " 예매율 : " + String(self.reservationRate)
    }
    
    var simpleCollectionInfo: String {
        return "\(String(self.reservationGrade))위(\(String(self.userRating))) / \(String(self.reservationRate))%"
    }
    
    var movieGradeText: String {
        switch grade {
        case 12:
            return "ic_12"
        case 15:
            return "ic_15"
        case 19:
            return "ic_19"
        default:
            return "ic_allages"
        }
    }
    
    var openingDate: String {
        return "개봉일 : " + date
    }
}
