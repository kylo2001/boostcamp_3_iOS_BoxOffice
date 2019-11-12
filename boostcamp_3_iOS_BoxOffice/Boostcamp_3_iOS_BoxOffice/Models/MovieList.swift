//
//  Movies.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    let orderType: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case orderType = "order_type"
        case movies
    }
}

enum MovieOrderType: Int {
    case reservation = 0
    case curation = 1
    case openingDate = 2
    
    // MARK: - Properties
    
    var navigationItemTitle: String {
        switch self {
        case .reservation:
            return "예매율순"
        case .curation:
            return "큐레이션"
        case .openingDate:
            return "개봉일순"
        }
    }
    
    var actionSheetTitle: String {
        switch self {
        case .reservation:
            return "예매율"
        case .curation:
            return "큐레이션"
        case .openingDate:
            return "개봉일"
        }
    }
    
    // MARK: - Method
    
    mutating func change(to newMovieOrderType: String) {
        switch newMovieOrderType {
        case "예매율":
            self = .reservation
        case "큐레이션":
            self = .curation
        case "개봉일":
            self = .openingDate
        default:
            break
        }
    }
}

enum MovieNotifications {
    static let MovieOrderTypeDidChange = "MovieOrderTypeDidChange"
}
