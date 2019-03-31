//
//  TubiAPI.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Alamofire
import Foundation
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

    let decoder = JSONDecoder()

    func get<T>(_ type: T.Type, endpoint: String) -> Observable<T?> where T : Decodable {
        return Observable.create({ observer -> Disposable in
            Alamofire.request(endpoint).responseData { [weak self] response in
                guard let data = response.result.value else {
                    observer.on(.next(nil))
                    return
                }
                let responseData = try? self?.decoder.decode(type, from: data)
                DispatchQueue.main.async {
                    observer.on(.next(responseData))
                }
            }
            return Disposables.create()
        })
    }
}
