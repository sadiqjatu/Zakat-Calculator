//
//  ZCLanguageButton.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 17/05/26.
//

import UIKit

class ZCLanguageButton: UIButton {
    
    private let buttonTitle      = UILabel()
    private let chevronImageView = UIImageView()
    
    var languageCode: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(title: String, languageCode: String) {
        self.init(frame: .zero)
        buttonTitle.text  = title
        self.languageCode = languageCode
    }
    
    
    private func configure() {
        layer.cornerRadius      = 20
        backgroundColor         = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1)
        buttonTitle.font        = UIFont.preferredFont(forTextStyle: .headline)
        buttonTitle.textColor   = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .white
        chevronImageView.contentMode = .scaleAspectFit
        
        let spacerView = UIView()
        
        let stackView  = UIStackView(arrangedSubviews: [buttonTitle, spacerView, chevronImageView])
        
        stackView.axis      = .horizontal
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
        stackView.isUserInteractionEnabled        = false
        buttonTitle.isUserInteractionEnabled      = false
        chevronImageView.isUserInteractionEnabled = false
    }
}
