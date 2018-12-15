//
//  FloatRatingView.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 09/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class UIFloatRatingView: UIStackView {
    
    private var imageViews = [UIImageView]()
    
    var starCount = 5
    
    var minRating: Double = 0.0
    var maxRating: Double = 10.0
    
    var rating: Double = 0 {
        didSet {
            setupImageViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStackView()
    }
    
    private func setupStackView() {
        spacing = 0
        alignment = .center
        distribution = .fillEqually
        
        for _ in 0..<starCount {
            let imageView = UIImageView()
            
            imageView.image = #imageLiteral(resourceName: "ic_star_large")
            imageView.contentMode = .scaleAspectFit
            
            addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    private func setupImageViews() {
        // 비율
        let ratio = (rating / (maxRating - minRating)) * Double(starCount)
        
        // rating의 정수부의 홀수 여부
        let isOdd: Bool = (rating - modf(rating).1).truncatingRemainder(dividingBy: 2) != 0
        
        // 비율 정수부
        var exponent = ratio - modf(ratio).1
        
        // 비율 가수부
        var mantissa = modf(ratio).1
        
        imageViews.forEach {
            if exponent > 0.0 {
                $0.image = #imageLiteral(resourceName: "ic_star_large_full")
                exponent -= 1.0
                return
            }
            
            if mantissa > 0.0, isOdd {
                $0.image = #imageLiteral(resourceName: "ic_star_large_half")
                mantissa = 0.0
            } else {
                $0.image = #imageLiteral(resourceName: "ic_star_large")
            }
        }
    }
}
