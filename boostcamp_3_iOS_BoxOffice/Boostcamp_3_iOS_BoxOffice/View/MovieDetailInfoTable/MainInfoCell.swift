//
//  MainInfoCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MainInfoCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet public weak var movieThumbImage: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieGradeImage: UIImageView!
    @IBOutlet private weak var genreDuration: UILabel!
    @IBOutlet private weak var movieOpeningDate: UILabel!
    @IBOutlet private weak var reservationRate: UILabel!
    @IBOutlet private weak var userRatingLabel: UILabel!
    @IBOutlet private weak var audience: UILabel!
    
    @IBOutlet private weak var userRatingView: UIFloatRatingView!
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else {
                movieThumbImage.image = UIImage(named: "img_placeholder")
                movieTitle.text = ""
                movieGradeImage.image = nil
                genreDuration.text = ""
                movieOpeningDate.text = ""
                reservationRate.text = ""
                userRatingLabel.text = ""
                audience.text = ""
                return
            }
            
            guard let thumbImagePath = movie.image else {
                return
            }
            
            ImageCache.getImage(from: thumbImagePath) { (cachedImage) in
                DispatchQueue.main.async {
                    self.movieThumbImage.image = cachedImage
                }
            }
            
            movieTitle.text = movie.title
            genreDuration.text = movie.genre! + "/" + String(movie.duration!) + "분"
            movieOpeningDate.text = movie.date + "개봉"
            movieGradeImage.image = UIImage(named: movie.movieGradeText)
            reservationRate.text = String(movie.reservationGrade) + "위 " + String(movie.reservationRate) + "%"
            userRatingLabel.text = String(movie.userRating)
            audience.text = String(movie.audience!).insertComma()
            userRatingView.rating = movie.userRating
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.movieThumbImage.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movie = nil
    }
}
