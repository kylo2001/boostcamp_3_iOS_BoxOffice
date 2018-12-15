//
//  MovieCollectionVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieCollectionVC: UICollectionViewController {
    
    // MARK: - Properties
    
    public var movieOrderType: MovieOrderType = .reservation
    
    private weak var indicator: UIActivityIndicatorView!
    
    private let cellId: String = "movieCollectionCell"
    
    private var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.setNavigationItemTitle()
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initIndicator()
        initCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovies()
    }
    
    // MARK: - Initialization Methods
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initIndicator() {
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
    
    private func initCollectionView() {
        self.navigationItem.title = ""
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        self.registerCustomCells(nibNames: ["MovieCollectionCell"], forCellReuseIdentifiers: [cellId])
        
        let sortingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(touchUpMovieOrderSettingButton))
        navigationItem.rightBarButtonItems = [sortingButton]
    }
    
    // MARK: - Setup Method
    
    private func setNavigationItemTitle() {
        self.navigationItem.title = movieOrderType.navigationItemTitle
    }
    
    // MARK: - Helper Methods
    
    @objc private func touchUpMovieOrderSettingButton(_ sender: UIBarButtonItem) {
        let handler: (UIAlertAction) -> Void
        
        handler = { (action: UIAlertAction) in
            if let newOrderType = action.title, newOrderType != self.movieOrderType.actionSheetTitle {
                self.movieOrderType.change(to: newOrderType)
                self.fetchMovies()
                
                guard let destination = self.tabBarController?.viewControllers?[0] as? UINavigationController else {
                    return
                }
                
                guard let movieTableVC = destination.rootViewController as? MovieTableVC else {
                    return
                }
                
                movieTableVC.movieOrderType = self.movieOrderType
            }
        }
        
        self.actionSheet(
            title: "정렬방식 선택",
            message: "영화를 어떤 순서로 정렬할까요?",
            actions: ["예매율", "큐레이션", "개봉일"],
            handler: handler
        )
    }
    
    // MARK: - Fetch Method
    
    private func fetchMovies() {
        self.indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NetworkManager.fetchMovies(orderType: self.movieOrderType) { (data, error) in
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
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailInfoTableVC = MovieDetailInfoTableVC()
        let movie = movies[indexPath.item]
        
        movieDetailInfoTableVC.movieId = movie.movieId
        
        self.navigationController?.pushViewController(movieDetailInfoTableVC, animated: true)
    }
    
    // MARK: - UIContentContainer Instance Method
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: (width * 337.5) / 187.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
