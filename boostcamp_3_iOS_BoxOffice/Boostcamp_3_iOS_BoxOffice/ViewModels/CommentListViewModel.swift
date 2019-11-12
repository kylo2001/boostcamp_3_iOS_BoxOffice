//
//  CommentListViewModel.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by DongWhan on 2019/11/13.
//  Copyright © 2019 Kim DongHwan. All rights reserved.
//

import Foundation

protocol CommentListViewModel {
    var comments: [CommentViewModel] { get }
}

class CommentListViewModelImpl: CommentListViewModel {
    var comments: [CommentViewModel]
    
    init(_ commentList: CommentList) {
        self.comments = commentList.comments.map() { CommentViewModel(comment: $0) }
    }
}
