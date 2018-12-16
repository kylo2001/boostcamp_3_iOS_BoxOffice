//
//  FloatRatingView.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 09/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class UIFloatRatingView: UIStackView {
    
    // MARK: - Properties
    
    public var rating: Double = 0 {
        didSet {
            setupImageViews()
        }
    }
    
    private var imageViews = [UIImageView]()
    
    private var starCount = 5
    
    private var minRating: Double = 0.0
    
    private var maxRating: Double = 10.0
    
    // MARK: - Lifecycle Method
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initStackView()
    }
    
    // MARK: - Initialization Method
    
    private func initStackView() {
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
    
    // MARK: - Setup Method
    
    private func setupImageViews() {
        let ratio = (rating / (maxRating - minRating)) * Double(starCount)
        
        let isOdd: Bool = (rating - modf(rating).1).truncatingRemainder(dividingBy: 2) != 0
        
        var exponent = ratio - modf(ratio).1
        
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
