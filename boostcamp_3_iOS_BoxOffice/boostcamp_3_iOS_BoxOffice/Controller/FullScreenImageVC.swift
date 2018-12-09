//
//  FullScreenImageVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class FullScreenImageVC: UIViewController, UIGestureRecognizerDelegate {
    var image: UIImage?
    
    lazy var fullScreenImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "img_placeholder"))
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(imageView)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setupImageView()
    }
    
    private func setupTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(dismissCurrentVC))
        self.fullScreenImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupImageView() {
        self.fullScreenImageView.addConstraints([
                NSLayoutConstraint(item: self.fullScreenImageView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.fullScreenImageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0),
                
                NSLayoutConstraint(item: self.fullScreenImageView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.fullScreenImageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
            ])
        
        guard let image = image else { return }
        fullScreenImageView.image = image
    }
    
    @objc func dismissCurrentVC() {
        self.dismiss(animated: false, completion: nil)
    }
    
}
