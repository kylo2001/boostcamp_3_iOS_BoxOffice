//
//  MovieListViewModel.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by DongWhan on 2019/11/12.
//  Copyright © 2019 Kim DongHwan. All rights reserved.
//

import Foundation

protocol MovieListViewModel {
    var movieOrderType: Dynamic<MovieOrderType> { get }
    var movies: [MovieViewModel] { get }
    
    func changeMovieOrderType(to orderType: String)
}

class MovieListViewModelImpl: NSObject, MovieListViewModel {
    let movieList: MovieList
    
    let movieOrderType: Dynamic<MovieOrderType>
    var movies: [MovieViewModel]
    
    init(_ movieList: MovieList) {
        self.movieList = movieList
        self.movieOrderType = Dynamic(MovieOrderType(rawValue: movieList.orderType) ?? .curation)
        self.movies = movieList.movies.map() { MovieViewModel(movie: $0) }
        
        super.init()
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    func changeMovieOrderType(to orderType: String) {
        if self.movieOrderType.value.actionSheetTitle != orderType {
            self.movieOrderType.value.change(to: orderType)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: MovieNotifications.MovieOrderTypeDidChange), object: self.movieOrderType.value)
        }
    }
    
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movieOrderTypeDidChangeNotification(_:)),
                                               name: NSNotification.Name(rawValue: MovieNotifications.MovieOrderTypeDidChange),
                                               object: nil)
    }

    fileprivate func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func movieOrderTypeDidChangeNotification(_ notification: NSNotification){
        if let orderType = notification.object as? MovieOrderType, self.movieOrderType.value != orderType {
            self.movieOrderType.value = orderType
        }
    }
}
