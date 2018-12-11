//
//  MovieTableCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieTableCell: UITableViewCell {
    @IBOutlet private weak var movieThumbImage: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieGradeImage: UIImageView!
    @IBOutlet private weak var movieSimpleInfo: UILabel!
    @IBOutlet private weak var movieOpeningDate: UILabel!
    
    var cache: NSCache = NSCache<NSString, UIImage>()
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else {
                movieThumbImage.image = UIImage(named: "img_placeholder")
                movieTitle.text = ""
                movieGradeImage.image = nil
                movieSimpleInfo.text = ""
                movieOpeningDate.text = ""
                return
            }
            
            guard let thumbImagePath = movie.thumb else {
                return
            }
            
            movieTitle.text = movie.title
            movieSimpleInfo.text = movie.simpleTableInfo
            movieOpeningDate.text = movie.openingDate
            movieGradeImage.image = UIImage(named: movie.movieGradeText)
            
            if let image = cache.object(forKey: thumbImagePath as NSString) {
                self.movieThumbImage.image = image
            } else {
                NetworkManager.downloadImage(path: thumbImagePath) { (data, error) in
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movie = nil
    }
}