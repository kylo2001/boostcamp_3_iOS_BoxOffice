//
//  MainInfoCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MainInfoCell: UITableViewCell {
    
    @IBOutlet weak var movieThumbImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGradeImage: UIImageView!
    @IBOutlet weak var genreDuration: UILabel!
    @IBOutlet weak var movieOpeningDate: UILabel!
    @IBOutlet weak var reservationRate: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var audience: UILabel!
    
//    @IBOutlet weak var userRatingView: FloatRatingView!
    
    var cache: NSCache = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.movieThumbImage.isUserInteractionEnabled = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    @objc func presentFullScreenImageVC() {
////        guard let movie = self.movie else { return }
//        let fullScreenImageVC = FullScreenImageVC()
//        fullScreenImageVC.image = self.movieThumbImage.image
//        
//        self.present(fullScreenImageVC, animated: false, completion: nil)
//    }
    
    var movie: Movie! {
        didSet {
            guard let thumbImagePath = movie.image else { return }
            
            movieTitle.text = movie.title
            genreDuration.text = movie.genre! + String(movie.duration!)
            movieOpeningDate.text = movie.date + "개봉"
            movieGradeImage.image = UIImage(named: movie.movieGradeText)
            reservationRate.text = String(movie.reservationRate)
            userRatingLabel.text = String(movie.userRating)
            audience.text = String(movie.audience!)
            
            //            cell.userRatingView.rating = (movie.userRating*5) / 10
            
            if let image = cache.object(forKey: thumbImagePath as NSString) {
                print("cacheImage")
                self.movieThumbImage.image = image
            } else {
                print("Loading image with path:", thumbImagePath)
                
                Manager.downloadImage(path: thumbImagePath) { (data, error) in
                    print("Finished download image data:", data ?? "")
                    
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
}
