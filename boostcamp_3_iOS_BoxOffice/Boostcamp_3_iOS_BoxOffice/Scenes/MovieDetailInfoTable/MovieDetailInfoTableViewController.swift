//
//  MovieDetailInfoTableVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieDetailInfoTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    private weak var indicator: UIActivityIndicatorView!
    
    struct Const {
        static let mainInfoCell = "mainInfoCell"
        static let synopsisCell = "synopsisCell"
        static let actorCell = "actorCell"
        static let firstCommentCell = "firstCommentCell"
        static let commentCell = "commentCell"
    }
    
    public var movieViewModel: MovieViewModel?
    private var commentListViewModel: CommentListViewModel?
    
    private let queue = DispatchQueue.global()
    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIndicator()
        setRefreshControl()
        setTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Initialization Methods
    
    private func setIndicator() {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.color = .gray
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        tableView.addSubview(indicator)
        
        tableView.addConstraints([
            NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 37),
            NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self.tableView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self.tableView, attribute: .centerY, multiplier: 1.0, constant: 0),
            ])
        
        self.indicator = indicator
    }
    
    private func setRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Networking...")
        refreshControl?.tintColor = .blue
        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func setTableView() {
        let nibNames = ["MainInfoCell", "SynopsisCell", "ActorCell", "FirstCommentCell", "CommentCell"]
        let identifiers = ["mainInfoCell", "synopsisCell", "actorCell", "firstCommentCell", "commentCell"]
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        registerCustomCells(nibNames: nibNames, forCellReuseIdentifiers: identifiers)
    }
    
    // MARK: - Helper Methods
    
    @objc private func handleRefreshControl() {
        fetchData()
    }
    
    @objc private func presentFullScreenImage() {
        guard let movieViewModel = movieViewModel else { return }
        let fullScreenImage = FullScreenImage()
        
        fullScreenImage.imageURL = movieViewModel.image
        present(fullScreenImage, animated: false, completion: nil)
    }
    
    // MARK: - Fetch Methods
    
    private func fetchData() {
        guard let movieId = movieViewModel?.movieId else {
            self.showAlert("영화 정보를 가져오지 못했습니다.\n다시 시도해주세요.") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        indicator.startAnimating()
    
        dispatchGroup.enter()
            NetworkManager.fetchMovie(movieId: movieId) { [weak self] (data, error) in
                guard let self = self else { return }
                
                if let movie = data {
                    let movieViewModel = MovieViewModel(movie: movie)
                    self.movieViewModel = movieViewModel
                } else {
                    self.movieViewModel = nil
                }
                
                self.dispatchGroup.leave()
            }
        
        dispatchGroup.enter()
            NetworkManager.fetchCommentList(movieId: movieId) { [weak self] (data, error) in
                guard let self = self else { return }
                
                if let commentList = data {
                    self.commentListViewModel = CommentListViewModelImpl(commentList)
                } else {
                    self.commentListViewModel = nil
                }
                
                self.dispatchGroup.leave()
            }
        
        dispatchGroup.notify(queue: queue) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.indicator.stopAnimating()
                self.refreshControl?.endRefreshing()
                self.refreshControl?.isHidden = true

                self.navigationItem.title = self.movieViewModel?.title

                if self.commentListViewModel == nil || self.movieViewModel == nil {
                    self.showAlert("네트워크가 좋지 않습니다..\n아래 방향으로 스와이프를 하여 새로고침을 해보세요.")
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - UITableView Instance Properties
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // MARK: - UITableView Instance Mothods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2:
            return 1
        case 3:
            return commentListViewModel?.comments.count ?? 0
        default:
            return 0
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieViewModel = movieViewModel else { return UITableViewCell() }
        guard let commentListViewModel = commentListViewModel else { return UITableViewCell() }
        
        let commentViewModel = commentListViewModel.comments[indexPath.row]
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.mainInfoCell, for: indexPath) as? MainInfoCell else {
                return UITableViewCell()
            }
            
            if cell.movieThumbImage.gestureRecognizers?.count ?? 0 == 0 {
                let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
                tapGesture.delegate = self
                tapGesture.addTarget(self, action: #selector(presentFullScreenImage))
                cell.movieThumbImage.addGestureRecognizer(tapGesture)
            }
            
            cell.movieViewModel = movieViewModel
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.synopsisCell, for: indexPath) as? SynopsisCell else {
                return UITableViewCell()
            }
            
            cell.movieViewModel = movieViewModel
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.actorCell, for: indexPath) as? ActorCell else {
                return UITableViewCell()
            }
            
            cell.movieViewModel = movieViewModel
            
            return cell
        case 3:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.firstCommentCell, for: indexPath) as? FirstCommentCell else {
                    return UITableViewCell()
                }
                
                cell.commentViewModel = commentViewModel
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.commentCell, for: indexPath) as? CommentCell else {
                    return UITableViewCell()
                }
                
                cell.commentViewModel = commentViewModel

                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}
