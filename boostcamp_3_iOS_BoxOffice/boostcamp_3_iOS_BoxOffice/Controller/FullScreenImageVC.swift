//
//  FullScreenImageVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class FullScreenImageVC: UIViewController, UIGestureRecognizerDelegate {
    var path: String?
    
    lazy var fullScreenImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "img_placeholder"))
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
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
        guard let imagePath = path else {
            return
        }
        
        Manager.downloadImage(path: imagePath) { (data, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.alert(error?.localizedDescription ?? "이미지를 받아오지 못했습니다.\n다시 시도해주세요.")
                    self.dismiss(animated: false, completion: nil)
                }
                return
            }
            DispatchQueue.main.async {
                self.fullScreenImageView.image = UIImage(data: data)
            }
        }
    }
    
    @objc func dismissCurrentVC() {
        self.dismiss(animated: false, completion: nil)
    }
}
