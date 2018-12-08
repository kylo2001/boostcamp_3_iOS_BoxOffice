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
    
    lazy var backGroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "img_placeholder"))
        self.view.addSubview(imageView)
        return imageView
    }()
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        guard let imagePath = path else {
//            return
//        }
//
//        Manager.downloadImage(path: imagePath) { (data, error) in
//            guard let data = data else {
//                self.alert(error?.localizedDescription ?? "이미지를 다운로드 하지 못했습니다.")
//                return
//            }
//            self.backGroundImageView.image = UIImage(data: data)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setupBackgroundImage()
        
    }
    
    private func setupBackgroundImage() {
        guard let image = image else { return }
        backGroundImageView.image = image
    }
    
    private func setupTapGesture() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(dismissCurrentVC))
        self.backGroundImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissCurrentVC() {
        self.dismiss(animated: false, completion: nil)
    }
    
}
