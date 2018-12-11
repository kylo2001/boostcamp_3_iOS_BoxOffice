//
//  MovieDetailInfoType.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 11/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

enum MovieDetailInfoTableSectionType: Int {
    case mainInfo = 0
    case sysnopsis
    case actor
    case firstComment
    case comment
    
    static var all = [
        MovieDetailInfoTableSectionType.mainInfo,
        MovieDetailInfoTableSectionType.sysnopsis,
        MovieDetailInfoTableSectionType.actor,
        MovieDetailInfoTableSectionType.firstComment,
        MovieDetailInfoTableSectionType.comment
    ]
    
    var nibNames: [String] {
        return identifiers.map { $0.capitalizeFirst }
    }
    
    var identifiers: [String] {
        return ["mainInfoCell", "synopsisCell", "actorCell", "firstCommentCell", "commentCell"]
//        return MovieDetailInfoTableCellType.all.map { $0.rawValue }
    }
}
