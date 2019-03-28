//
//  UIImageViewExtensions.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit

extension UIImageView {
    // a basic async fetch image
    func setImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        URLSession.shared.dataTask(with: url) { [weak self] data,_,_ in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}
