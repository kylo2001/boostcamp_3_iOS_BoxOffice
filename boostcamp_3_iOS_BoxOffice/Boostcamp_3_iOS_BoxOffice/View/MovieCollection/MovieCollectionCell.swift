//
//  MovieCollectionCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet private weak var movieThumbImage: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieGradeImage: UIImageView!
    @IBOutlet private weak var movieSimpleInfo: UILabel!
    @IBOutlet private weak var movieOpeningDate: UILabel!
    
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
            
            ImageCache.getImage(from: thumbImagePath) { (cachedImage) in
                DispatchQueue.main.async {
                    self.movieThumbImage.image = cachedImage
                }
            }
            
            movieTitle.text = movie.title
            movieSimpleInfo.text = movie.simpleCollectionInfo
            movieOpeningDate.text = movie.openingDate
            movieGradeImage.image = UIImage(named: movie.movieGradeText)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movie = nil
    }
}
