//
//  Caching.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/27/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Foundation

protocol Caching {
    func add(key: String, value: MovieItem)
    func get(key: String) -> MovieItem?
    func isValid(key: String) -> Bool
}
