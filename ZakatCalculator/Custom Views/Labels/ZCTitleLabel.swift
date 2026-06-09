//
//  ZCTitleLabel.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 16/05/26.
//

import UIKit

enum CategoryType {
    case wsCalculator, gscalculator, baCalculator
}

class ZCTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font          = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
        textColor                 = .label
        minimumScaleFactor        = 0.5
        lineBreakMode             = .byTruncatingTail
    }
    
    
    func set(categoryType: CategoryType) {
        switch categoryType {
            
        case .wsCalculator:
            text = "Wealth & Savings"
        case .gscalculator:
            text = "Gold & Silver"
        case .baCalculator:
            text = "Business Assets"
        }
    }
}
