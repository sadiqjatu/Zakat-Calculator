//
//  ZCIconView.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 18/05/26.
//

import UIKit

enum IconType {
    case cash, gold, business
}

class ZCIconView: UIView {
    
    let icon = UIImageView()
    

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure(30)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(backgroundColor: UIColor, icon: UIImage?, tintColor: UIColor, iconSize: CGFloat) {         //designated initializer
        super.init(frame: .zero)
        self.icon.image      = icon
        self.backgroundColor = backgroundColor
        self.tintColor       = tintColor
        configure(iconSize)
    }
    
    
    private func configure(_ iconSize: CGFloat) {
        layer.cornerRadius  = 27
        clipsToBounds       = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(icon)
        icon.contentMode    = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: iconSize),
            icon.widthAnchor.constraint(equalToConstant: iconSize)
        ])
        
    }
    
    
    func set(iconType: IconType) {
        switch iconType {
            
        case .cash:
            backgroundColor = Colors.lightGreen
            icon.image      = Icons.cash
            icon.tintColor  = Colors.darkGreen
        case .gold:
            backgroundColor = Colors.lightAmber
            icon.image      = Icons.gold
            icon.tintColor  = Colors.amber
        case .business:
            backgroundColor = Colors.lightBlue
            icon.image      = Icons.briefcase
            icon.tintColor  = Colors.darkBlue
        }
    }
}
