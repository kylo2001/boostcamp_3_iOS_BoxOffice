//
//  MovieTableVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieTableVC: UITableViewController {

    // MARK: - Properties
    
    public var movieOrderType: MovieOrderType = .reservation
    
    private weak var indicator: UIActivityIndicatorView!
    
    private let cellId: String = "movieTableCell"
    
    private var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.setNavigationItemTitle()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupIndicator()
        setupRefreshControl()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovies()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        self.registerCustomCells(nibNames: ["MovieTableCell"], forCellReuseIdentifiers: [cellId])
    }
    
    private func setupIndicator() {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = .gray
    
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        self.tableView.addSubview(indicator)
        
        self.tableView.addConstraints([
            NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self.tableView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self.tableView, attribute: .centerY, multiplier: 1.0, constant: 0),
            ])
        
        self.indicator = indicator
    }
    
    private func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .blue
        self.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        getMovies()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = ""
        let movieOrderSettingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(touchUpMovieOrderSettingButton))
        navigationItem.rightBarButtonItems = [movieOrderSettingButton]
    }
    
    @objc func touchUpMovieOrderSettingButton(_ sender: UIBarButtonItem) {
        let handler: (UIAlertAction) -> Void
        
        handler = { (action: UIAlertAction) in
            if let newOrderType = action.title, newOrderType != self.movieOrderType.actionSheetTitle {
                self.movieOrderType.change(to: newOrderType)
            }
            
            self.getMovies()
            self.setNavigationItemTitle()
        }
        
        self.actionSheet(
            title: "정렬방식 선택",
            message: "영화를 어떤 순서로 정렬할까요?",
            actions: ["예매율", "큐레이션", "개봉일"],
            handler: handler
        )
    }
    
    private func setNavigationItemTitle() {
        self.navigationItem.title = movieOrderType.navigationItemTitle
    }
    
    // MARK: -
    
    private func getMovies() {
        self.indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkManager.getMovies(orderType: self.movieOrderType) { (data, error) in
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                    self.refreshControl?.isHidden = true
                    self.indicator.stopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                guard let movies = data else {
                    DispatchQueue.main.async {
                        // 1. movie 데이터의 키값 매칭에 실패했을 경우
                        // 2. 정렬 순서와 맞지 않은 영화 정보를 가지고 있는 경우
                        // 3. 네트워크가 끊어졌을 경우
                        self.alert("네트워크가 좋지 않습니다..\n아래 방향으로 스와이프를 하여 새로고침을 해보세요.") {
                            self.navigationItem.title = ""
                        }
                    }
                    return
                }
                self.movies = movies
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MovieTableCell else {
            return UITableViewCell()
        }
        
        let movie = self.movies[indexPath.row]
        cell.movie = movie
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailInfoTableVC = MovieDetailInfoTableVC()
        let movie = movies[indexPath.row]
        
        movieDetailInfoTableVC.movieId = movie.movieId
        
        self.navigationController?.pushViewController(movieDetailInfoTableVC, animated: true)
    }
}
