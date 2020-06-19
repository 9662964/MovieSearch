//
//  MovieController.swift
//  MovieSearch
//
//  Created by iljoo Chae on 6/19/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit

struct StringConstants {
    fileprivate static let baseURLString = "https://api.themoviedb.org/3/"
    fileprivate static let searchComponent = "search/movie"
    fileprivate static let movieQueryKey = "query"
    fileprivate static let apiKey = "api_key"
    fileprivate static let apiValue = "f9a9a17791d5431242869398ea68a702"
    fileprivate static let imageBaseURLString = "https://image.tmdb.org/t/p/w500"
}

class MovieController {
    
    static func fetchMovie(searchTerm: String, completion: @escaping (Result<[Movie],MovieSearchError>) -> Void) {
        
        guard let baseURL = URL(string: StringConstants.baseURLString) else {return completion(.failure(.invalidURL))}
        let searchURL = baseURL.appendingPathComponent(StringConstants.searchComponent)
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let apiQueryItem = URLQueryItem(name: StringConstants.apiKey, value: StringConstants.apiValue )
        //let movieSearchQuery = URLQueryItem(name: StringConstants.movieQueryKey, value: searchTerm)
        let movieSearchQuery = URLQueryItem(name: StringConstants.movieQueryKey, value: searchTerm)
        components?.queryItems = [apiQueryItem,movieSearchQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from:data)
                let movieLists = topLevelObject.results
                return completion(.success(movieLists))
            }catch{
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchPoster(movie: Movie, completion: @escaping (Result<UIImage, MovieSearchError>) -> Void) {
        guard let baseURL = URL(string: StringConstants.imageBaseURLString) else {return completion(.failure(.invalidURL))}
        guard let postPath = movie.posterPath else {return}
        
        let finalURL = baseURL.appendingPathComponent(postPath)
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            return completion(.success(image))
        }.resume()
    }
    
}


