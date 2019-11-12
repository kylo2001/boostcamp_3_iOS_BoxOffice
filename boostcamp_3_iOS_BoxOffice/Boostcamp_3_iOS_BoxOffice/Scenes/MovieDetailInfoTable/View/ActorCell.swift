//
//  ActorCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class ActorCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet private weak var directorName: UILabel!
    @IBOutlet private weak var actorName: UILabel!
    
    var movieViewModel: MovieViewModel? {
        didSet{
            guard let movieViewModel = movieViewModel else {
                directorName.text = ""
                actorName.text = ""
                return
            }
            
            directorName.text = movieViewModel.director
            actorName.text = movieViewModel.actor
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieViewModel = nil
    }
}
