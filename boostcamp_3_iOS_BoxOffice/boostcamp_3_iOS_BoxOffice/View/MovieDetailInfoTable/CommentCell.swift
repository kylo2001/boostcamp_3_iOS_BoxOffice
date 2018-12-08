//
//  CommentCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var writerName: UILabel!
//    @IBOutlet weak var userRating: FloatRatingView!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var contents: UITextView!
    
    var comment: Comment! {
        didSet{
            self.writerName.text = comment.writer
            //  self.userRating.rating = (comment.rating*5) / 10
            self.timestamp.text = comment.timestamp.data
            self.contents.text = comment.contents
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contents.isScrollEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
