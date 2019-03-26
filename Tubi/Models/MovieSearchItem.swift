//
//  MovieSearchItem.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Foundation

class MovieSearchItem: Codable {
    let title: String
    let id: String
    let image: String
    
    var imageUrl: URL? {
        return URL(string: image)
    }
}
