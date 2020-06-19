//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by iljoo Chae on 6/19/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
protocol PresentErrorToUserDelegate: class {
    func presentErrorToUser(error: LocalizedError)
}

class MovieTableViewCell: UITableViewCell {

    //MARK - Outlet
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moveVoteLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            updateViews()
        }
    }
  
    weak var delegate: PresentErrorToUserDelegate?
    
    func updateViews() {
    
        guard let movie = movie else {return}
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
        moveVoteLabel.text = "Rating: \(String(movie.voteAverage))"
        
        MovieController.fetchPoster(movie: movie) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.movieImageView.image = image
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.presentErrorToUser(error: error)
                }
                print(error.localizedDescription)
            }
        }
    }
}
