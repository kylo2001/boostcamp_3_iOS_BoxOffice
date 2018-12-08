//
//  MovieTableCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieTableCell: UITableViewCell {
    @IBOutlet weak var movieThumbImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGradeImage: UIImageView!
    @IBOutlet weak var movieSimpleInfo: UILabel!
    @IBOutlet weak var movieOpeningDate: UILabel!
    
    var cache: NSCache = NSCache<NSString, UIImage>()
    
    var movie: Movie! {
        didSet {
            guard let thumbImagePath = movie.thumb else { return }
            
            movieTitle.text = movie.title
            movieSimpleInfo.text = movie.simpleTableInfo
            movieOpeningDate.text = movie.openingDate
            movieGradeImage.image = UIImage(named: movie.movieGradeText)
            
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