//
//  MovieDetailViewController.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MovieDetailViewController: UIViewController {
    private let movieId: String
    private let services: Services
    private let disposeBag = DisposeBag()

    private let loadingSpinner = UIActivityIndicatorView(style: .whiteLarge)
    private let imageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()

    private var movieItem = BehaviorRelay<MovieItem?>(value: nil)

    init(movieId: String, services: Services) {
        self.movieId = movieId
        self.services = services
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

        movieItem.asObservable().subscribe(onNext: { [weak self] movieItem in
            guard let strongSelf = self,
                let movieItem = movieItem,
                let imageUrl = movieItem.imageUrl,
                let index = movieItem.index else {
                return
            }
            strongSelf.imageView.setImage(from: imageUrl).disposed(by: strongSelf.disposeBag)
            strongSelf.titleLabel.text = movieItem.title
            strongSelf.title = "Index: \(index)"
        }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        services.cache.get(movieId: movieId)
            .observeOn(MainScheduler.instance)
            .bind(to: movieItem)
            .disposed(by: disposeBag)
    }
}
