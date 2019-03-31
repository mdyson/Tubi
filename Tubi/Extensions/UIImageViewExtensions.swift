//
//  UIImageViewExtensions.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension UIImageView {
    // a basic async fetch image
    func setImage(from url: URL, placeholder: UIImage? = nil) -> Disposable {
        image = placeholder
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { UIImage(data: $0) }
            .ifEmpty(default: placeholder)
            .observeOn(MainScheduler.instance)
            .bind(to: rx.image)
    }
}
