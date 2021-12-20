//
//  Extension+ActivityIndicator.swift
//  UnsplashTest v1
//
//  Created by Максим on 05/11/2021.
//

import UIKit

extension UIActivityIndicatorView {
    public func turnOn() {
        isHidden = false
        startAnimating()
    }
    public func turnOff() {
        isHidden = true
        stopAnimating()
    }
}
