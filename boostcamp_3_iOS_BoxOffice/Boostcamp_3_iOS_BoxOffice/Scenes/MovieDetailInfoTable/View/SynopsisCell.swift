//
//  SynopsisCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class SynopsisCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet private weak var synopsisTextView: UITextView!
    
    var movieViewModel: MovieViewModel? {
        didSet{
            guard let movieViewModel = movieViewModel else {
                synopsisTextView.text = ""
                return
            }
            
            self.synopsisTextView.text = movieViewModel.synopsis
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        synopsisTextView.isScrollEnabled = false
        synopsisTextView.isEditable = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieViewModel = nil
    }
}
