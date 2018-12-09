//
//  MovieDetailInfoTableVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieDetailInfoTableVC: UITableViewController, UIGestureRecognizerDelegate {
    
    var movieId: String?
    var movie: Movie?
    var comments: [Comment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableView()
        getMovie()
        getComments()
    }
    
    func setupRefreshControl() {
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
        let mainInfoCell = UINib(nibName: "MainInfoCell", bundle: nil)
        tableView.register(mainInfoCell, forCellReuseIdentifier: "mainInfoCell")
        
        let synopsisCell = UINib(nibName: "SynopsisCell", bundle: nil)
        tableView.register(synopsisCell, forCellReuseIdentifier: "synopsisCell")
        
        let actorCell = UINib(nibName: "ActorCell", bundle: nil)
        tableView.register(actorCell, forCellReuseIdentifier: "actorCell")
        
        let firstCommentCell = UINib(nibName: "FirstCommentCell", bundle: nil)
        tableView.register(firstCommentCell, forCellReuseIdentifier: "firstCommentCell")
        
        let commentCell = UINib(nibName: "CommentCell", bundle: nil)
        tableView.register(commentCell, forCellReuseIdentifier: "commentCell")
    }
    
    private func getMovie() {
        guard let movieId = movieId else { return }
        Manager.getMovie(movieId: movieId) { (data, error) in
            self.refreshControl?.endRefreshing()
            guard let movie = data else {
                self.alert(error?.localizedDescription ?? "영화 정보를 가져오지 못했습니다.")
                return
            }
            self.movie = movie
            self.navigationItem.title = movie.title
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getComments() {
        guard let movieId = movieId else { return }
        Manager.getComments(movieId: movieId) { (data, error) in
            self.refreshControl?.endRefreshing()
            guard let comments = data else {
                self.alert(error?.localizedDescription ?? "한줄평 정보를 가져오지 못했습니다.")
                return
            }
            self.comments = comments
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
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
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @objc func presentFullScreenImageVC() {
        print("presentFullScreenImageVC")
        guard let movie = self.movie else { return }
        let fullScreenImageVC = FullScreenImageVC()
        fullScreenImageVC.path = movie.image
        
        self.present(fullScreenImageVC, animated: false, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = self.movie else { return UITableViewCell() }
        guard let comments = self.comments else { return UITableViewCell() }
        let comment = comments[indexPath.row]
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainInfoCell", for: indexPath) as? MainInfoCell else { return UITableViewCell() }
            
            if cell.movieThumbImage.gestureRecognizers?.count ?? 0 == 0 {
                let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
                tapGesture.delegate = self
                tapGesture.addTarget(self, action: #selector(presentFullScreenImageVC))
                cell.movieThumbImage.addGestureRecognizer(tapGesture)
            }
            
            cell.movie = movie
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "synopsisCell", for: indexPath) as? SynopsisCell else { return UITableViewCell() }
            
            cell.movie = movie
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath) as? ActorCell else { return UITableViewCell() }
            
            cell.movie = movie
            
            return cell
        case 3:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "firstCommentCell", for: indexPath) as? FirstCommentCell else { return UITableViewCell() }
                
                cell.comment = comment
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell else { return UITableViewCell() }
                cell.comment = comment

                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}
