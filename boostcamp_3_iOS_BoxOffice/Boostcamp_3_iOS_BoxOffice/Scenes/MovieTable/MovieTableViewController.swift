//
//  MovieTableVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {

    // MARK: - Properties
    
    private weak var indicator: UIActivityIndicatorView!
    
    private let cellId: String = "movieTableCell"
    
    struct Style {
        static let tableViewCellHeight: CGFloat = 160.0
    }
    
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
    
    private func setupUI() {
        // UITableView
        tableView.tableFooterView = UIView()
        self.registerCustomCells(nibNames: ["MovieTableCell"], forCellReuseIdentifiers: [cellId])
        
        // UIActivityIndicatorView
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = .gray
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        tableView.addSubview(indicator)
        
        tableView.addConstraints([
            NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: tableView, attribute: .centerY, multiplier: 1.0, constant: 0),
        ])
        
        self.indicator = indicator
        
        // UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Networking...")
        refreshControl?.tintColor = .blue
        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)

        // UINavigationItem
        navigationItem.title = "큐레이션"
        let movieOrderSettingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(touchUpMovieOrderSettingButton))
        navigationItem.rightBarButtonItems = [movieOrderSettingButton]
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
                self.refreshControl?.endRefreshing()
                self.refreshControl?.isHidden = true
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
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewModel?.movies.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MovieTableCell else {
            return UITableViewCell()
        }
        
        let movieViewModel = self.movieListViewModel?.movies[indexPath.row]
        cell.movieViewModel = movieViewModel
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Style.tableViewCellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieListViewModel = movieListViewModel else { return }
        let viewController = MovieDetailInfoTableViewController()
        let movieViewModel = movieListViewModel.movies[indexPath.row]
        
        viewController.movieViewModel = movieViewModel
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
