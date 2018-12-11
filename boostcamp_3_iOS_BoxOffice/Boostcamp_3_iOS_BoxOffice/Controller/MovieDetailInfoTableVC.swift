//
//  MovieDetailInfoTableVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieDetailInfoTableVC: UITableViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    public var movieId: String?
    
    private weak var indicator: UIActivityIndicatorView!
    
    private var movie: Movie? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var comments: [Comment]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        setupRefreshControl()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMovie()
        getComments()
    }
    
    // MARK: - Setup Methods
    
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
        getMovie()
        getComments()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        let nibNames = ["MainInfoCell", "SynopsisCell", "ActorCell", "FirstCommentCell", "CommentCell"]
        let identifiers = ["mainInfoCell", "synopsisCell", "actorCell", "firstCommentCell", "commentCell"]
        
        self.registerCustomCells(nibNames: nibNames, forCellReuseIdentifiers: identifiers)
    }
    
    @objc func presentFullScreenImage() {
        guard let movie = self.movie else {
            return
        }
        
        let fullScreenImage = FullScreenImage()
        fullScreenImage.path = movie.image
        
        self.present(fullScreenImage, animated: false, completion: nil)
    }
    
    // MARK: -
    
    private func getMovie() {
        guard let movieId = movieId else {
            self.alert("영화 정보를 가져오지 못했습니다.\n다시 시도해주세요.") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        self.indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkManager.getMovie(movieId: movieId) { (data, error) in
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                    self.refreshControl?.isHidden = true
                    self.indicator.stopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                guard let movie = data else {
                    DispatchQueue.main.async {
                        self.alert("네트워크가 좋지 않습니다..\n아래 방향으로 스와이프를 하여 새로고침을 해보세요.")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.navigationItem.title = movie.title
                }
                
                self.movie = movie
            }
        }
    }
    
    private func getComments() {
        guard let movieId = movieId else {
            self.alert("한줄평 정보를 가져오지 못했습니다.\n다시 시도해주세요.") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        self.indicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkManager.getComments(movieId: movieId) { (data, error) in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.refreshControl?.endRefreshing()
                }
                
                guard let comments = data else {
                    DispatchQueue.main.async {
                        self.alert("네트워크가 좋지 않습니다..\n아래 방향으로 스와이프를 하여 새로고침을 해보세요.")
                    }
                    return
                }
                
                self.comments = comments
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
            guard let comments = comments else { return 0 }
            return comments.count
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
        guard let movie = self.movie else {
            return UITableViewCell()
        }
        
        guard let comments = self.comments else {
            return UITableViewCell()
        }
        
        if comments.count == 0 {
            return UITableViewCell()
        }
        
        let comment = comments[indexPath.row]
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainInfoCell", for: indexPath) as? MainInfoCell else {
                return UITableViewCell()
            }
            
            if cell.movieThumbImage.gestureRecognizers?.count ?? 0 == 0 {
                let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
                tapGesture.delegate = self
                tapGesture.addTarget(self, action: #selector(presentFullScreenImage))
                cell.movieThumbImage.addGestureRecognizer(tapGesture)
            }
            
            cell.movie = movie
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "synopsisCell", for: indexPath) as? SynopsisCell else {
                return UITableViewCell()
            }
            
            cell.movie = movie
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath) as? ActorCell else {
                return UITableViewCell()
            }
            
            cell.movie = movie
            
            return cell
        case 3:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "firstCommentCell", for: indexPath) as? FirstCommentCell else {
                    return UITableViewCell()
                }
                
                cell.comment = comment
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell else {
                    return UITableViewCell()
                }
                
                cell.comment = comment

                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}
