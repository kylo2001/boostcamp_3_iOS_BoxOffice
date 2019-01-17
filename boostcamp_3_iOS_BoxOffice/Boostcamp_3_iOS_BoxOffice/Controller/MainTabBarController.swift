//
//  MainTabBarViewController.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewControllers()
    }
    
    // MARK: - Initialization Methods
    
    private func initViewControllers() {
        let flowLayout = UICollectionViewFlowLayout()
        
        viewControllers = [
            generateNavigationController(for: MovieTableVC(), title: "Table", image: #imageLiteral(resourceName: "ic_list")),
            generateNavigationController(for: MovieCollectionVC(collectionViewLayout: flowLayout), title: "Collection", image: #imageLiteral(resourceName: "ic_collection"))
        ]
    }
    
    // MARK: - Helper Methods
    
    private func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        return navController
    }
}

