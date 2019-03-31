//
//  TubiAPI.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TubiAPI {
    enum APIError: Error {
        case urlError
        case responseError
    }
    
    enum Endpoints {
        static let movies = "https://us-central1-modern-venture-600.cloudfunctions.net/api/movies"
        static func movies(id: String) -> String {
            return "\(Endpoints.movies)/\(id)"
        }
    }

    func get<T>(_ type: T.Type, endpoint: String) -> Observable<T?> where T : Decodable {
        guard let url = URL(string: endpoint) else {
            return Observable.error(APIError.urlError)
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url)).map({ data -> T? in
            return try? JSONDecoder().decode(type, from: data)
        }).observeOn(MainScheduler.instance)
    }
}
