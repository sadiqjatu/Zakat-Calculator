//
//  UIView+Ext.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 16/05/26.
//

import UIKit

extension UIView {
    
    var firstResponder: UIView? {
        if isFirstResponder { return self}
        
        for subview in subviews {
            if let responder = subview.firstResponder {
                return responder
            }
        }
        
        return nil
    }
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
