//
//  UIImageViewExtensions.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import Alamofire
import UIKit

extension UIImageView {
    // a basic async fetch image
    func setImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        Alamofire.request(url).responseData { [weak self] response in
            guard let data = response.result.value else {
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
