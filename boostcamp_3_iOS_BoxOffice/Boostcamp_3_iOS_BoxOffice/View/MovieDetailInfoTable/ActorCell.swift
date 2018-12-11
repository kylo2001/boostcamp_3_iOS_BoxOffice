//
//  ActorCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class ActorCell: UITableViewCell {
    
    @IBOutlet private weak var directorName: UILabel!
    @IBOutlet private weak var actorName: UILabel!
    
    var movie: Movie? {
        didSet{
            guard let movie = movie else {
                directorName.text = ""
                actorName.text = ""
                return
            }
            
            self.directorName.text = movie.director
            self.actorName.text = movie.actor
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movie = nil
    }
}
