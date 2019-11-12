//
//  MovieViewModel.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by DongWhan on 2019/11/12.
//  Copyright © 2019 Kim DongHwan. All rights reserved.
//

import Foundation

class MovieViewModel {
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
    
    init(movie: Movie) {
        self.reservationRate = movie.reservationRate
        self.genre = movie.genre
        self.director = movie.director
        self.userRating = movie.userRating
        self.duration = movie.duration
        self.title = movie.title
        self.grade = movie.grade
        self.reservationGrade = movie.reservationGrade
        self.synopsis = movie.synopsis
        self.audience = movie.audience
        self.thumb = movie.thumb
        self.date = movie.date
        self.movieId = movie.movieId
        self.actor = movie.actor
        self.image = movie.image
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
