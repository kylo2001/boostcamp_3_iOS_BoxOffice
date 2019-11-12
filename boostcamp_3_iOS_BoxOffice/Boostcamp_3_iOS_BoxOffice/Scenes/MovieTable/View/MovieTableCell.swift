//
//  MovieTableCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieTableCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet private weak var movieThumbImage: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieGradeImage: UIImageView!
    @IBOutlet private weak var movieSimpleInfo: UILabel!
    @IBOutlet private weak var movieOpeningDate: UILabel!
    
//    var movie: Movie? {
//        didSet {
//            guard let movie = movie else {
//                movieThumbImage.image = UIImage(named: "img_placeholder")
//                movieTitle.text = ""
//                movieGradeImage.image = nil
//                movieSimpleInfo.text = ""
//                movieOpeningDate.text = ""
//                return
//            }
//
//            guard let thumbImageURL = movie.thumb else {
//                return
//            }
//
//            ImageCache.getImage(from: thumbImageURL) { (image) in
//                DispatchQueue.main.async {
//                    self.movieThumbImage.image = image
//                }
//            }
//
//            movieTitle.text = movie.title
//            movieSimpleInfo.text = movie.simpleTableInfo
//            movieOpeningDate.text = movie.openingDate
//            movieGradeImage.image = UIImage(named: movie.movieGradeText)
//        }
//    }
    
    var movieViewModel: MovieViewModel? {
        didSet {
            guard let movieViewModel = movieViewModel else {
                movieThumbImage.image = UIImage(named: "img_placeholder")
                movieTitle.text = ""
                movieGradeImage.image = nil
                movieSimpleInfo.text = ""
                movieOpeningDate.text = ""
                return
            }
            
            guard let thumbImageURL = movieViewModel.thumb else { return }

            ImageCache.getImage(from: thumbImageURL) { (image) in
                DispatchQueue.main.async {
                    self.movieThumbImage.image = image
                }
            }

            movieTitle.text = movieViewModel.title
            movieSimpleInfo.text = movieViewModel.simpleTableInfo
            movieOpeningDate.text = movieViewModel.openingDate
            movieGradeImage.image = UIImage(named: movieViewModel.movieGradeText)
            
        }
    }
    
    // MARK: - Lifecycle Method
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieViewModel = nil
    }
}
