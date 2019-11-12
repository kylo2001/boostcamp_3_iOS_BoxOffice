//
//  MovieCollectionVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private weak var indicator: UIActivityIndicatorView!
    
    private var refreshControl = UIRefreshControl()
    
    private let cellId: String = "movieCollectionCell"
    
    private var movieListViewModel: MovieListViewModel? {
        didSet {
            fillUI()
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchMovieList()
    }
    
    // MARK: - Initialization Methods
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // UIActivityIndicatorView
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
        
        self.navigationItem.title = "큐레이션"
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        self.registerCustomCells(nibNames: ["MovieCollectionCell"], forCellReuseIdentifiers: [cellId])
        
        let sortingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(touchUpMovieOrderSettingButton))
        navigationItem.rightBarButtonItems = [sortingButton]
        
        collectionView.addSubview(refreshControl)
        refreshControl.attributedTitle = NSAttributedString(string: "Networking...")
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func fillUI() {
        guard let movieListViewModel = movieListViewModel else { return }
        
        movieListViewModel.movieOrderType.bind() { [weak self] newOrderType in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.navigationItem.title = newOrderType.navigationItemTitle
                self.fetchMovieList()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    @objc private func handleRefreshControl() {
        fetchMovieList()
    }
    
    @objc private func touchUpMovieOrderSettingButton(_ sender: UIBarButtonItem) {
        showActionSheet(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", actions: ["예매율", "큐레이션", "개봉일"]) { [weak self] (action) in
            guard let self = self else { return }
            guard let movieListViewModel = self.movieListViewModel else { return }
            
            if let newOrderType = action.title {
                movieListViewModel.changeMovieOrderType(to: newOrderType)
            }
        }
    }
    
    // MARK: - Fetch Method
    
    private func fetchMovieList() {
        indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NetworkManager.fetchMovieList(orderType: movieListViewModel?.movieOrderType.value ?? .curation) { [ weak self] (response, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.refreshControl.endRefreshing()
                self.refreshControl.isHidden = true
            }
            
            guard let movieList = response else {
                DispatchQueue.main.async {
                    self.showAlert("네트워크가 좋지 않습니다..\n아래 방향으로 스와이프를 하여 새로고침을 해보세요.") {
                        self.navigationItem.title = ""
                    }
                }
                return
            }
            
            self.movieListViewModel = MovieListViewModelImpl(movieList)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieListViewModel?.movies.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as?  MovieCollectionCell else {
            return UICollectionViewCell()
        }
        
        let movieViewModel = movieListViewModel?.movies[indexPath.item]
        cell.movieViewModel = movieViewModel
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailInfoTableVC = MovieDetailInfoTableViewController()
        let movieViewModel = movieListViewModel?.movies[indexPath.item]
        
        movieDetailInfoTableVC.movieViewModel = movieViewModel
        
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

extension MovieCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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
