//
//  TubiAPI.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Foundation

class TubiAPI {
    enum APIError: Error {
        case urlError
        case responseError
    }
    
    enum Endpoints {
        static let movies = "https://us-central1-modern-venture-600.cloudfunctions.net/api/movies"
        
        static func movie(id: String) -> String {
            return "\(Endpoints.movies)/\(id)"
        }
    }
    
    func get<T>(_ type: T.Type, endpoint: String, response: @escaping (_ data: T?, _ error: Error?) -> Void) where T : Decodable {
        guard let url = URL(string: endpoint) else {
            response(nil, APIError.urlError)
            return
        }
        URLSession.shared.dataTask(with: url) { data,_,_ in
            if let data = data {
                let decoder = JSONDecoder()
                if let responseData = try? decoder.decode(type, from: data) {
                    DispatchQueue.main.async {
                        response(responseData, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        response(nil, APIError.responseError)
                    }
                }
            }
        }.resume()
    }
}
