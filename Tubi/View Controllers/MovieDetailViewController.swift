//
//  MovieDetailViewController.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    let movieId: String
    var cache: MovieCacheService

    let loadingSpinner = UIActivityIndicatorView(style: .whiteLarge)
    let imageView = UIImageView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    init(movieId: String, cache: MovieCacheService) {
        self.movieId = movieId
        self.cache = cache
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple

        view.addSubview(loadingSpinner)
        view.addSubview(imageView)
        view.addSubview(titleLabel)

        loadingSpinner.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        imageView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp_bottom).offset(10)
        }

        if let movieItem = cache.get(key: movieId) {
            imageView.setImage(from: movieItem.imageUrl!)
            titleLabel.text = movieItem.title
        } else {
            makeRequest()
        }
    }

    func makeRequest() {
        loadingSpinner.startAnimating()
        TubiAPI().get(MovieItem.self, endpoint: TubiAPI.Endpoints.movie(id: movieId)) { [weak self] (movieItem, error) in
            guard let movieItem = movieItem else {
                let alert = UIAlertController(title: "Error", message: "Failed to fetch movie details.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
                return
            }
            self?.loadingSpinner.stopAnimating()
            self?.imageView.setImage(from: movieItem.imageUrl!)
            self?.titleLabel.text = movieItem.title
            self?.cache.add(key: movieItem.id, value: movieItem)
        }
    }
}
