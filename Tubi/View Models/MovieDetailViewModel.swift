//
//  MovieDetailViewModel.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/31/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewModel {
    private let movieId: String
    private let services: Services

    let disposeBag = DisposeBag()
    let movieItem = BehaviorRelay<MovieItem?>(value: nil)

    init(movieId: String, services: Services) {
        self.movieId = movieId
        self.services = services
    }

    func makeRequest() {
        services.cache.get(movieId: movieId)
            .observeOn(MainScheduler.instance)
            .bind(to: movieItem)
            .disposed(by: disposeBag)
    }
}
