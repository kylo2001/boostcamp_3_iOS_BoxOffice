//
//  MovieCollectionVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    weak var indicator: UIActivityIndicatorView!
    
    let cellId: String = "movieCollectionCell"
    
    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.setMovieOrderAndNavigationTitle()
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Initialize Methods
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        setupCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovies()
    }
    
    // MARK: - Setup Methods
    
    private func setupIndicator() {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        self.collectionView.addSubview(indicator)
        
        self.collectionView.addConstraints([
            NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self.collectionView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self.collectionView, attribute: .centerY, multiplier: 1.0, constant: 0),
            ])
        
        self.indicator = indicator
    }
    
    private func setupCollectionView() {
        self.navigationItem.title = ""
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        self.registerCustomCells(nibNames: ["MovieCollectionCell"], forCellReuseIdentifiers: [cellId])
        
        let sortingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(touchUpSortingBarButtonItem))
        navigationItem.rightBarButtonItems = [sortingButton]
    }
    
    @objc func touchUpSortingBarButtonItem(_ sender: UIBarButtonItem) {
        let handler: (UIAlertAction) -> Void
        
        handler = { (action: UIAlertAction) in
            switch action.title {
            case "예매율":
                Sort.shared.orderType = 0
            case "큐레이션":
                Sort.shared.orderType = 1
            case "개봉일":
                Sort.shared.orderType = 2
            default:
                print("취소")
            }
            
            self.getMovies()
            self.setMovieOrderAndNavigationTitle()
        }
        
        self.actionSheet(title: "정렬방식 선택",message: "영화를 어떤 순서로 정렬할까요?", actions: ["예매율", "큐레이션", "개봉일"], handler: handler)
    }
    
    private func setMovieOrderAndNavigationTitle() {
        switch Sort.shared.orderType {
        case 0:
            self.navigationItem.title = "예매율순"
        case 1:
            self.navigationItem.title = "큐레이션"
        case 2:
            self.navigationItem.title = "개봉일순"
        default:
            break
        }
    }
    
    // MARK: -
    
    private func getMovies() {
        self.indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            DataProvider.getMovies(orderType: Sort.shared.orderType) { (data, error) in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                guard let movies = data else {
                    DispatchQueue.main.async {
                        self.alert("네트워크가 좋지 않습니다..\n'Table'탭으로 이동하고 아래 방향으로 스와이프를 하여 새로고침을 해보세요.") {
                            self.navigationItem.title = ""
                        }
                    }
                    return
                }
                
                self.movies = movies
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as?  MovieCollectionCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.item]
        cell.movie = movie
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: (width * 337.5) / 187.5 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailInfoTableVC = MovieDetailInfoTableVC()
        let movie = movies[indexPath.item]
        
        movieDetailInfoTableVC.movieId = movie.movieId
        
        self.navigationController?.pushViewController(movieDetailInfoTableVC, animated: true)
    }
    
    // MARK: - 
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
