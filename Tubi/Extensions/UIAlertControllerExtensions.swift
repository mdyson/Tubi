//
//  UIAlertControllerExtensions.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/28/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func ok(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        return alert
    }

    class func error(message: String) -> UIAlertController {
        return ok(title: "Error", message: message)
    }
}
