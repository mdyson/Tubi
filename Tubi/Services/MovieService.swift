//
//  CacheService.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/27/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Foundation
import RxSwift

class MovieService: MovieCaching {
    private var cache = LRUCache<String, MovieItem>(size: 5)
    private let api: TubiAPI

    init(api: TubiAPI) {
        self.api = api
    }

    func get(movieId: String) -> Observable<MovieItem?> {
        return Observable<MovieItem?>.create { observer -> Disposable in
            if let movieItem = self.cache.get(key: movieId) {
                observer.on(.next(movieItem))
            } else {
                return self.api.get(MovieItem.self, endpoint: TubiAPI.Endpoints.movies(id: movieId))
                    .do(onNext: { [weak self] (movieItem) in
                        if let movieItem = movieItem {
                            self?.cache.add(key: movieId, value: movieItem)
                        }
                    })
                    .catchErrorJustReturn(nil)
                    .subscribe(observer)
            }
            return Disposables.create()
        }
    }
}
