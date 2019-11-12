//
//  FullScreenImageVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class FullScreenImage: UIViewController, UIGestureRecognizerDelegate {
   
    // MARK: - Properties
    
    public var imageURL: String?
    
    private weak var indicator: UIActivityIndicatorView!
    
    private lazy var fullScreenImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "img_placeholder"))
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        self.view.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIndicator()
        setTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupImageView()
    }
    
    // MARK: - Initialization Methods
    
    private func setIndicator() {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        self.fullScreenImageView.addSubview(indicator)
        
        self.fullScreenImageView.addConstraints([
            NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self.fullScreenImageView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self.fullScreenImageView, attribute: .centerY, multiplier: 1.0, constant: 0),
            ])
        
        self.indicator = indicator
    }
    
    private func setTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(dismissCurrentVC))
        self.fullScreenImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Helper Method
    
    @objc private func dismissCurrentVC() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Setup Method
    
    private func setupImageView() {
        guard let imageURL = imageURL else {
            return
        }
        
        self.indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ImageCache.getImage(from: imageURL) { (cachedImage) in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.fullScreenImageView.image = cachedImage
            }
        }
    }
}
