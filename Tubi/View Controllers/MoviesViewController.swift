//
//  ViewController.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MoviesViewController: UIViewController {
    private let reuseIdentifier = "MovieCell"
    private let itemsPerRow = 2

    private let services: Services
    private let movies = BehaviorRelay<[MovieItem]>(value: [])
    private let disposeBag = DisposeBag()

    private let collectionView: UICollectionView = {
        let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        layout.minimumLineSpacing = sectionInsets.left
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let loadingSpinner = UIActivityIndicatorView(style: .whiteLarge)
    
    init(services: Services) {
        self.services = services
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        super.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .purple
        title = "Movies"

        view.addSubview(collectionView)
        view.addSubview(loadingSpinner)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalTo(view)
        }

        loadingSpinner.startAnimating()
        services.api.get([MovieItem].self, endpoint: TubiAPI.Endpoints.movies)
            .do(onError: { error in
                self.presentError(message: "Failed to load movies.")
                self.loadingSpinner.stopAnimating()
            }, onCompleted: {
                self.loadingSpinner.stopAnimating()
            })
            .catchErrorJustReturn(nil)
            .flatMap({ Observable.from(optional: $0) })
            .bind(to: movies)
            .disposed(by: disposeBag)

        movies.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: MovieCollectionViewCell.self)) { _, model, cell in
                cell.movieItem.accept(model)
        }.disposed(by: disposeBag)

        collectionView.rx.modelSelected(MovieItem.self).asObservable().subscribe(onNext: { movieItem in
            let movieDetailVC = MovieDetailViewController(movieId: movieItem.id, services: self.services)
            self.navigationController?.pushViewController(movieDetailVC, animated: true)
        }).disposed(by: disposeBag)

        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left * CGFloat(itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)

        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
}
