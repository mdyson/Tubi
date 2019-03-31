//
//  Services.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/27/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Foundation

class Services {
    let api = TubiAPI()
    let cache: MovieCaching

    init() {
        cache = MovieService(api: api)
    }
}
