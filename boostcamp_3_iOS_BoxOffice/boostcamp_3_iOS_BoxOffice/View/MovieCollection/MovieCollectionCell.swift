//
//  MovieCollectionCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    @IBOutlet weak var movieThumbImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGradeImage: UIImageView!
    @IBOutlet weak var movieSimpleInfo: UILabel!
    @IBOutlet weak var movieOpeningDate: UILabel!
    
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
            
            guard let thumbImagePath = movie.thumb else { return }
            
            movieTitle.text = movie.title
            movieSimpleInfo.text = movie.simpleCollectionInfo
            movieOpeningDate.text = movie.openingDate
            movieGradeImage.image = UIImage(named: movie.movieGradeText)
            
            if let image = cache.object(forKey: thumbImagePath as NSString) {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movie = nil
    }
}
