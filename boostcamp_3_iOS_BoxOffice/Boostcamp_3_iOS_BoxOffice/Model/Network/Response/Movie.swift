//
//  Movie.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

//{
//    "reservation_rate": 35.5,
//    "genre": "판타지, 드라마",
//    "director": "김용화",
//    "user_rating": 7.98,
//    "duration": 139,
//    "title": "신과함께-죄와벌",
//    "reservation_grade": 1,
//    "grade": 12,
//    "synopsis": "저승 법에 의하면, 모든 인간은 사후 49일 동안 7번의 재판을 거쳐야만 한다. 살인, 나태, 거짓, 불의, 배신, 폭력, 천륜 7개의 지옥에서 7번의 재판을 무사히 통과한 망자만이 환생하여 새로운 삶을 시작할 수 있다. \n\n “김자홍 씨께선, 오늘 예정 대로 무사히 사망하셨습니다” \n\n화재 사고 현장에서 여자아이를 구하고 죽음을 맞이한 소방관 자홍, 그의 앞에 저승차사 해원맥과 덕춘이 나타난다.\n자신의 죽음이 아직 믿기지도 않는데 덕춘은 정의로운 망자이자 귀인이라며 그를 치켜세운다.\n저승으로 가는 입구, 초군문에서 그를 기다리는 또 한 명의 차사 강림, 그는 차사들의 리더이자 앞으로 자홍이 겪어야 할 7개의 재판에서 변호를 맡아줄 변호사이기도 하다.\n염라대왕에게 천년 동안 49명의 망자를 환생시키면 자신들 역시 인간으로 환생시켜 주겠다는 약속을 받은 삼차사들, 그들은 자신들이 변호하고 호위해야 하는 48번째 망자이자 19년 만에 나타난 의로운 귀인 자홍의 환생을 확신하지만, 각 지옥에서 자홍의 과거가 하나 둘씩 드러나면서 예상치 못한 고난과 맞닥뜨리는데…\n\n누구나 가지만 아무도 본 적 없는 곳, 새로운 세계의 문이 열린다!",
//    "audience": 11676822,
//    "date": "2017-12-20",
//    "id": "5a54c286e8a71d136fb5378e",
//    "actor": "하정우(강림), 차태현(자홍), 주지훈(해원맥), 김향기(덕춘)",
//    "image": "http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg"
//}

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
