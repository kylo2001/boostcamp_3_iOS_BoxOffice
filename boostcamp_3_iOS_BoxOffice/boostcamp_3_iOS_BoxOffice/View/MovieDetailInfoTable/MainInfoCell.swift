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
//    @IBOutlet weak var userRatingView: FloatRatingView!
    @IBOutlet weak var audience: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.movieThumbImage.isUserInteractionEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
