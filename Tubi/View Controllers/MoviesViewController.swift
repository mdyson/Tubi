//
//  ViewController.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit

class MoviesViewController: UICollectionViewController {
    private let reuseIdentifier = "MovieCell"
    private let itemsPerRow = 2
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    private var movies = [MovieItem]()
    private var movieCacheService = MovieCacheService()
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .purple
        title = "Movies"
        
        TubiAPI().get([MovieItem].self, endpoint: TubiAPI.Endpoints.movies) { [weak self] (movies, error) in
            guard let movies = movies else {
                return
            }
            self?.movies = movies
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MoviesViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieItem = movies[indexPath.item]
        navigationController?.pushViewController(MovieDetailViewController(movieId: movieItem.id, cache: movieCacheService), animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MoviesViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let cell = cell as? MovieCollectionViewCell {
            cell.configure(movieItem: movies[indexPath.item])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
