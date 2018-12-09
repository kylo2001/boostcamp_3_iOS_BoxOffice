//
//  FirstCommentCell.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class FirstCommentCell: UITableViewCell {
    
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var writerName: UILabel!
//    @IBOutlet weak var userRating: FloatRatingView!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var contents: UITextView!
    
    var comment: Comment? {
        didSet{
            guard let comment = comment else {
                print("inti FirstCommentCell")
                writerName.text = ""
                timestamp.text = ""
                contents.text = ""
                return
            }
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepareForReuse for FirstCommentCell")
        self.comment = nil
    }
}
