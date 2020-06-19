//
//  MovieListTableViewController.swift
//  MovieSearch
//
//  Created by iljoo Chae on 6/19/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    var movies : [Movie] = []
    @IBOutlet weak var movieSearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        movieSearchBar.delegate = self
    }
    
    func search() {
        guard let searchTerm = movieSearchBar.text, !searchTerm.isEmpty else {return}
        MovieController.fetchMovie(searchTerm: searchTerm) { (result) in
            switch result {
            case .success(let movie):
                self.movies = movie
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        let movie = movies[indexPath.row]
        cell.movie = movie
        // Configure the cell...
        cell.updateViews()
        return cell
    }
}

extension MovieListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
}
