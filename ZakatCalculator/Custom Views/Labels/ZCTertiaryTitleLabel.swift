//
//  ZCTertiaryTitleLabel.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 19/05/26.
//

import UIKit

class ZCTertiaryTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(title: String, textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.text          = title
        self.textAlignment = textAlignment
        self.font          = UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth  = true
        textColor                  = .label
        minimumScaleFactor         = 0.5
        lineBreakMode              = .byTruncatingTail
    }
}
