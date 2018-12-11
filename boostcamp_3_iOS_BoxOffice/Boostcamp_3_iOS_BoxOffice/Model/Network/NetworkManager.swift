//
//  Manager.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    // MARK: - Properties
    
    enum URLString {
        static let base = "http://connect-boxoffice.run.goorm.io/"
        
        case movie(String)
        case movies(Int)
        case comments(String)
        case image(String)
        
        var stringValue: String {
            switch self {
            case .movie(let movieId): // http://connect-boxoffice.run.goorm.io/movie?id=5a54c286e8a71d136fb5378e
                return URLString.base + "movie?id=" + movieId
            case .movies(let orderType): //http://connect-boxoffice.run.goorm.io/movies?order_type=1
                return URLString.base + "movies?order_type=" + String(orderType)
            case .comments(let movieId): // http://connect-boxoffice.run.goorm.io/comments?movie_id=5a54c286e8a71d136fb5378e
                return URLString.base + "comments?movie_id=" + movieId
            case .image(let imageURL):
                return imageURL
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    enum FetchResult {
        case success(Data)
        case failure
    }
    
    // MARK: - GET Request mothod
    
    static func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let result = fetchResult(data: data, response: response, error: error)
            
            switch result {
            case .failure:
                completion(nil, error)
                
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    completion(responseObject, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Fetch Methods
    
    static func fetchMovie(movieId: String, completion: @escaping (Movie?, Error?) -> Void) {
        taskForGETRequest(url: URLString.movie(movieId).url, responseType: Movie.self) { response, error in
            guard let response = response else {
                completion(nil, error)
                return
            }
            completion(response, nil)
        }
    }
    
    static func fetchMovies(orderType: MovieOrderType, completion: @escaping ([Movie]?, Error?) -> Void) {
        taskForGETRequest(url: URLString.movies(orderType.rawValue).url, responseType: Movies.self) { response, error in
            guard let response = response else {
                completion(nil, error)
                return
            }
            completion(response.movies, nil)
        }
    }
    
    static func fetchComments(movieId: String, completion: @escaping ([Comment]?, Error?) -> Void) {
        taskForGETRequest(url: URLString.comments(movieId).url, responseType: Comments.self) { response, error in
            guard let response = response else {
                completion(nil, error)
                return
            }
            completion(response.comments, nil)
        }
    }
    
    static func fetchImage(imageURL: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: URLString.image(imageURL).url) { data, response, error  in
            let result = fetchResult(data: data, response: response, error: error)
            switch result {
            case .failure:
                completion(nil, error)
                
            case .success(let data):
                completion(data, nil)
            }
        }
        task.resume()
    }
    
    static private func fetchResult(data: Data?, response: URLResponse?, error: Error?) -> FetchResult {
        guard let fetchedData = data, error == nil else {
            return .failure
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return .failure
        }
        
        return .success(fetchedData)
    }
}

