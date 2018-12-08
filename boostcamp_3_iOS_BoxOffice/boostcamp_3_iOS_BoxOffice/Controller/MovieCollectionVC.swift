//
//  MovieCollectionVC.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MovieCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var movies: [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    let cellId: String = "movieCollectionCell"
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMovieOrderAndNavigationTitle()
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
    
    private func setupCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        let nib = UINib(nibName: "MovieCollectionCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellId)
        
        getMovies(orderType: Sort.shared.orderType)
        
        let sortingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(touchUpSortingBarButtonItem))
        navigationItem.rightBarButtonItems = [sortingButton]
    }
    
    private func setMovieOrderAndNavigationTitle() {
        getMovies(orderType: Sort.shared.orderType)
        
        switch Sort.shared.orderType {
        case 0:
            self.navigationItem.title = "예매율순"
        case 1:
            self.navigationItem.title = "큐레이션"
        case 2:
            self.navigationItem.title = "개봉일순"
        default:
            print("default")
        }
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
            self.setMovieOrderAndNavigationTitle()
        }
        
        self.actionSheet(title: "정렬방식 선택",message: "영화를 어떤 순서로 정렬할까요?", actions: ["예매율", "큐레이션", "개봉일"], handler: handler)
    }
    
    //MARK: UICollectionView
    
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let movieDetailInfoTableVC = UITableViewController() as? MovieDetailInfoTableVC else {
            return
        }

        let movie = movies[indexPath.item]

        movieDetailInfoTableVC.movieId = movie.movieId

        self.navigationController?.pushViewController(movieDetailInfoTableVC, animated: true)
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
