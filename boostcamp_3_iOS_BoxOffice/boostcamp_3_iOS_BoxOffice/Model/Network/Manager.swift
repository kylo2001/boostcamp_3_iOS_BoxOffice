//
//  Manager.swift
//  boostcamp_3_iOS_BoxOffice
//
//  Created by Kim DongHwan on 08/12/2018.
//  Copyright © 2018 Kim DongHwan. All rights reserved.
//

import Foundation

class Manager {
    enum Endpoints {
        static let base = "http://connect-boxoffice.run.goorm.io/"
        
        case getMovie(String)
        case getMovies(Int)
        case getComments(String)
        case posterImage(String)
        
        var stringValue: String {
            switch self {
            case .getMovie(let movieId): // http://connect-boxoffice.run.goorm.io/movie?id=5a54c286e8a71d136fb5378e
                return Endpoints.base + "movie?id=" + movieId
            case .getMovies(let orderType): //http://connect-boxoffice.run.goorm.io/movies?order_type=1
                return Endpoints.base + "movies?order_type=" + String(orderType)
            case .getComments(let movieId): // http://connect-boxoffice.run.goorm.io/comments?movie_id=5a54c286e8a71d136fb5378e
                return Endpoints.base + "comments?movie_id=" + movieId
            case .posterImage(let posterPath):
                return posterPath
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error) // 에러 핸들링 제대로 해줘야한다.!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                //                do {
                //                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data) as Error
                //                    DispatchQueue.main.async {
                //                        completion(nil, errorResponse)
                //                    }
                //                } catch {
                //                    DispatchQueue.main.async {
                //                        completion(nil, error)
                //                    }
                //                }
            }
        }
        task.resume()
    }
    
    class func getMovie(movieId: String, completion: @escaping (Movie?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getMovie(movieId).url, responseType: Movie.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getMovies(orderType: Int, completion: @escaping ([Movie]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getMovies(orderType).url, responseType: Movies.self) { response, error in
            if let response = response {
                completion(response.movies, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getComments(movieId: String, completion: @escaping ([Comment]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getComments(movieId).url, responseType: Comments.self) { response, error in
            if let response = response {
                completion(response.comments, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.posterImage(path).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
}
