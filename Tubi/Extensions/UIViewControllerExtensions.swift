//
//  UIViewControllerExtensions.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/28/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentError(message: String) {
        present(UIAlertController.error(message: message), animated: true)
    }
}
