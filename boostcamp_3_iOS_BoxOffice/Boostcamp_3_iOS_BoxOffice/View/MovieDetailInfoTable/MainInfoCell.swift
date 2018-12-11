//
//  MainInfoCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MainInfoCell: UITableViewCell {
    
    @IBOutlet private weak var movieThumbImage: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieGradeImage: UIImageView!
    @IBOutlet private weak var genreDuration: UILabel!
    @IBOutlet private weak var movieOpeningDate: UILabel!
    @IBOutlet private weak var reservationRate: UILabel!
    @IBOutlet private weak var userRatingLabel: UILabel!
    @IBOutlet private weak var audience: UILabel!
    
//    @IBOutlet private weak var userRatingView: FloatRatingView!
    
    var cache: NSCache = NSCache<NSString, UIImage>()
    
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
            
            movieTitle.text = movie.title
            genreDuration.text = movie.genre! + "/" + String(movie.duration!) + "분"
            movieOpeningDate.text = movie.date + "개봉"
            movieGradeImage.image = UIImage(named: movie.movieGradeText)
            reservationRate.text = String(movie.reservationGrade) + "위 " + String(movie.reservationRate) + "%"
            userRatingLabel.text = String(movie.userRating)
            audience.text = String(movie.audience!).insertComma()
            
            //            cell.userRatingView.rating = (movie.userRating*5) / 10
            
            if let image = cache.object(forKey: thumbImagePath as NSString) {
                self.movieThumbImage.image = image
            } else {
                DataProvider.downloadImage(path: thumbImagePath) { (data, error) in
                    guard let data = data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if let movieImage = UIImage(data: data) {
                            self.cache.setObject(movieImage, forKey: thumbImagePath as NSString)
                            self.movieThumbImage.image = movieImage
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMovieThumbImageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movie = nil
    }
    
    private func setupMovieThumbImageView() {
        self.movieThumbImage.isUserInteractionEnabled = true
        
        if self.movieThumbImage.gestureRecognizers?.count ?? 0 == 0 {
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
            tapGesture.delegate = self
            tapGesture.addTarget(MovieDetailInfoTableVC.self, action: #selector(MovieDetailInfoTableVC.presentFullScreenImage))
            self.movieThumbImage.addGestureRecognizer(tapGesture)
        }
        
    }
}
