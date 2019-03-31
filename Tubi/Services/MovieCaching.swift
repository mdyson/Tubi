//
//  Caching.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/27/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Foundation
import RxSwift

protocol MovieCaching {
    func get(movieId: String) -> Observable<MovieItem?>
}
