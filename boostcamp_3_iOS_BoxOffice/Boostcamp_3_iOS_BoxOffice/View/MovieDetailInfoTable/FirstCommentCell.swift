//
//  FirstCommentCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class FirstCommentCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet private weak var addCommentButton: UIButton!
    @IBOutlet private weak var writerName: UILabel!
    @IBOutlet private weak var userRating: UIFloatRatingView!
    @IBOutlet private weak var timestamp: UILabel!
    @IBOutlet private weak var contents: UITextView!
    
    var comment: Comment? {
        didSet{
            guard let comment = comment else {
                writerName.text = ""
                timestamp.text = ""
                contents.text = ""
                return
            }
            
            self.writerName.text = comment.writer
            self.userRating.rating = comment.rating
            self.timestamp.text = comment.timestamp.date
            self.contents.text = comment.contents
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contents.isScrollEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.comment = nil
    }
}
