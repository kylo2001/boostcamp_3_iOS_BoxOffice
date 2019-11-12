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
    
    var commentViewModel: CommentViewModel? {
        didSet{
            guard let commentViewModel = commentViewModel else {
                writerName.text = ""
                timestamp.text = ""
                contents.text = ""
                return
            }
            
            writerName.text = commentViewModel.writer
            userRating.rating = commentViewModel.rating
            timestamp.text = commentViewModel.timestamp.date
            contents.text = commentViewModel.contents
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contents.isScrollEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentViewModel = nil
    }
}
