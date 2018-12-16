//
//  ImageCache.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 11/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import UIKit

struct ImageCache {
    
    // MARK: - Property
    
    static private let memory = NSCache<NSNumber, UIImage>()
    
    // MARK: - Methods
    
    static public func getImage(from urlString: String, completion: @escaping (UIImage) -> ()) {
        if let cachedImage = isCached(from: urlString) {
            completion(cachedImage)
        } else {
            NetworkManager.fetchImage(imageURL: urlString) { (data, error) in
                guard let data = data else {
                    completion(#imageLiteral(resourceName: "imageNotFound"))
                    return
                }
                
                let fetchedImage = UIImage(data: data)
                
                guard let image = fetchedImage else {
                    completion(#imageLiteral(resourceName: "imageNotFound"))
                    return
                }
                
                store(image, forKey: urlString.hash as NSNumber)
                completion(image)
            }
        }
    }
    
    static private func isCached(from urlString: String) -> UIImage? {
        let key = urlString.hash as NSNumber
        
        guard let image = memory.object(forKey: key) else {
            if let imageURL = getDirectory(forKey: key) {
                return UIImage(contentsOfFile: imageURL.path)
            }
            
            return nil
        }
        
        return image
    }
    
    static private func store(_ image: UIImage, forKey key: NSNumber) {
        memory.setObject(image, forKey: key)
        guard let dataPath = getDirectory(forKey: key) else { return }
        guard let image = image.jpegData(compressionQuality: 1.0) else { return }
        
        do {
            try image.write(to: dataPath)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static private func getDirectory(forKey key: NSNumber) -> URL? {
        let fileManager = FileManager()
    
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let dataPath = documentsDirectory.appendingPathComponent(key.stringValue)
        
        return dataPath
    }
}
