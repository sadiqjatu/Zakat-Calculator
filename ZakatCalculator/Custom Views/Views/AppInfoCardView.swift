//
//  AppInfoCardView.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 10/06/26.
//

import UIKit

class AppInfoCardView: UIView {
    
    let infoIconview = ZCIconView(backgroundColor: Colors.lightGreen, icon: Icons.infoCircle, tintColor: Colors.darkGreen, iconSize: 30)
    let titleLabel   = ZCTitleLabel(textAlignment: .natural, fontSize: 16)
    let subtitleLabel = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 14)
    let descriptionLabel = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 14)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureAlignment()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(title: String, subtitle: String, description: String) {
        super.init(frame: .zero)
        self.titleLabel.text       = title
        self.subtitleLabel.text    = subtitle
        self.descriptionLabel.text = description
        configure()
        configureAlignment()
    }
    
    
    private func configure() {
        addSubviews(infoIconview, titleLabel, subtitleLabel, descriptionLabel)
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius  = 16
        layer.masksToBounds = false
        
        infoIconview.icon.layer.cornerRadius = 22
        descriptionLabel.numberOfLines       = 3
        backgroundColor                      = Colors.ultraLightGreen
        
        titleLabel.textColor                 = Colors.ultraDarkGreen
        subtitleLabel.textColor              = Colors.darkGreen
        descriptionLabel.textColor           = Colors.darkGreen
        
        
        NSLayoutConstraint.activate([
            infoIconview.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            infoIconview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            infoIconview.widthAnchor.constraint(equalToConstant: 44),
            infoIconview.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: infoIconview.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: infoIconview.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: infoIconview.trailingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    
    private func configureAlignment() {
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        let isSystemRTL     = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
        
        if currentLanguage == "ar" && !isSystemRTL {
            subtitleLabel.textAlignment = .right
            titleLabel.textAlignment    = .right
        } else if currentLanguage == "en" && isSystemRTL {
            subtitleLabel.textAlignment = .left
            titleLabel.textAlignment    = .left
        }
    }
}
