//
//  MoviesViewModel.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/31/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MoviesViewModel {
    let services: Services
    let disposeBag = DisposeBag()

    let movies = BehaviorRelay<[MovieItem]>(value: [])
    let loadingObservable = BehaviorRelay<Bool>(value: false)
    let errorMessageObservable = BehaviorRelay<String?>(value: nil)

    init(services: Services) {
        self.services = services
    }

    func makeRequest() {
        loadingObservable.accept(true)
        services.api.get([MovieItem].self, endpoint: TubiAPI.Endpoints.movies)
            .do(onError: { [errorMessageObservable, loadingObservable] error in
                errorMessageObservable.accept("Failed to load movies.")
                loadingObservable.accept(false)
            }, onCompleted: { [loadingObservable] in
                loadingObservable.accept(false)
            })
            .catchErrorJustReturn([])
            .flatMap({ Observable.from(optional: $0) })
            .bind(to: movies)
            .disposed(by: disposeBag)
    }
}
