//
//  SynopsisCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class SynopsisCell: UITableViewCell {
    
    @IBOutlet weak var synopsisTextView: UITextView!
    
    var movie: Movie? {
        didSet{
            guard let movie = movie else {
                synopsisTextView.text = ""
                return
            }
            self.synopsisTextView.text = movie.synopsis
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.synopsisTextView.isScrollEnabled = false
        self.synopsisTextView.isEditable = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movie = nil
    }
}
