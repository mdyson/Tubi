//
//  MovieSearchItem.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Foundation

struct MovieItem: Codable {
    let title: String
    let id: String
    let image: String
    let index: Int?
    
    var imageUrl: URL? {
        return URL(string: image)
    }
}
