//
//  MovieTableVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieTableVC: UITableViewController {

    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let cellId: String = "movieTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func getMovies(orderType: Int) {
        Manager.getMovies(orderType: orderType) { (data, error) in
            guard let movies = data else {
                self.alert(error?.localizedDescription ?? "영화 정보를 가져오지 못했습니다.")
                return
            }
            self.movies = movies
        }
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "MovieTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        getMovies(orderType: 0)
        
        let sortingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(touchUpSortingBarButtonItem))
        navigationItem.rightBarButtonItems = [sortingButton]
    }
    
    @objc func touchUpSortingBarButtonItem(_ sender: UIBarButtonItem) {
        let handler: (UIAlertAction) -> Void
        
        handler = { (action: UIAlertAction) in
            switch action.title {
            case "예매율":
                self.navigationItem.title = "예매율순"
                self.getMovies(orderType: 0)
            case "큐레이션":
                self.navigationItem.title = "큐레이션"
                self.getMovies(orderType: 1)
            case "개봉일":
                self.navigationItem.title = "개봉일순"
                self.getMovies(orderType: 2)
            default:
                print("취소")
            }
            print("action pressed \(action.title ?? "")")
        }
        
        self.actionSheet(title: "정렬방식 선택",message: "영화를 어떤 순서로 정렬할까요?", actions: ["예매율", "큐레이션", "개봉일"], handler: handler)
    }
    
    //MARK: UITableView
    
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
