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
            guard let url = URL(string: movie.thumb ?? "") else { return }
            
            if let image = cache.object(forKey: url.absoluteString as NSString) {
                print("cacheImage")
                self.movieThumbImage.image = image
            } else {
                movieTitle.text = movie.title
                movieSimpleInfo.text = movie.simpleTableInfo
                movieOpeningDate.text = movie.openingDate
                movieGradeImage.image = UIImage(named: movie.movieGradeText)
                
                print("Loading image with url:", movie.thumb ?? "")
                
                Manager.downloadImage(path: movie.thumb ?? "") { (data, error) in
                    print("Finished download image data:", data ?? "")
                    
                    guard let data = data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if let movieImage = UIImage(data: data) {
                            self.cache.setObject(movieImage, forKey: url.absoluteString as NSString)
                            self.movieThumbImage.image = movieImage
                        }
                    }
                }
            }
        }
    }
}
