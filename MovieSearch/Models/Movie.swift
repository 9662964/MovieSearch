//
//  Movie.swift
//  MovieSearch
//
//  Created by iljoo Chae on 6/19/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import Foundation

struct TopLevelObject: Codable {
    let results: [Movie]
}
struct Movie: Codable {
    private enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case title = "title"
        case overview = "overview"
    }
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
}
