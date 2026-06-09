//
//  ZCCollapsibleCardView.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 24/05/26.
//

import UIKit

class ZCCollapsibleCardView: UIView {
    
    let iconImageView    = ZCIconView(backgroundColor: Colors.lightGreen, icon: nil, tintColor: Colors.darkGreen, iconSize: 30)
    let titleLabel       = ZCTitleLabel(textAlignment: .natural, fontSize: 20)
    let subtitleLabel    = ZCSecondaryTitleLabel(textAlignment: .natural, fontSize: 14)
    let chevronImageview = UIImageView()
    let descriptionLabel = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 16)
    
    let padding: CGFloat = 20
    
    var collapsedConstraint: NSLayoutConstraint!
    var expandedConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTapGesture()
        configure()
        configureAlignment()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(icon: UIImage?, title: String, description: String) {
        super.init(frame: .zero)
        self.iconImageView.icon.image = icon
        self.titleLabel.text          = title
        self.descriptionLabel.text    = description
        configureTapGesture()
        configure()
        configureAlignment()
    }
    
    
    func configureTapGesture() {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    
    private func configure() {
        addSubviews(iconImageView, titleLabel, subtitleLabel, chevronImageview, descriptionLabel)
        
        translatesAutoresizingMaskIntoConstraints                  = false
        chevronImageview.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius               = 16
//        layer.borderColor                = UIColor.systemGray5.cgColor
//        layer.borderWidth                = 1
        backgroundColor                  = .secondarySystemGroupedBackground
        layer.shadowColor                = UIColor.black.cgColor
        layer.shadowOffset               = CGSize(width: 0, height: 4)
        layer.shadowOpacity              = 0.05
        layer.shadowRadius               = 10
        layer.masksToBounds              = false
        
        iconImageView.layer.cornerRadius = 22
        chevronImageview.tintColor       = .systemGray3
        chevronImageview.contentMode     = .scaleAspectFit
        
        let currentLanguage              = UserDefaults.standard.string(forKey: "selectedLanguage")
        chevronImageview.image           = (currentLanguage == "ar") ? Icons.chevronLeft : Icons.chevronRight
        
        subtitleLabel.text               = EducationVCStrings.subtitleLabel.localized
        descriptionLabel.numberOfLines   = 0
        descriptionLabel.isHidden        = true
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageview.leadingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: chevronImageview.leadingAnchor, constant: -12),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 16),
            
            chevronImageview.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            chevronImageview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chevronImageview.widthAnchor.constraint(equalToConstant: 20),
            chevronImageview.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        ])
        
        collapsedConstraint = subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        expandedConstraint  = descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        
        collapsedConstraint.isActive = true
    }
    
    
    private func configureAlignment() {
        let isSystemRTL     = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        
        if currentLanguage == "ar" && !isSystemRTL {
            titleLabel.textAlignment    = .right
            subtitleLabel.textAlignment = .right
        } else if currentLanguage == "en" && isSystemRTL {
            titleLabel.textAlignment    = .left
            subtitleLabel.textAlignment = .left
        }
    }
    
    
    @objc func cardTapped() {
        descriptionLabel.isHidden.toggle()
        
        if descriptionLabel.isHidden {
            expandedConstraint.isActive  = false
            collapsedConstraint.isActive = true
            chevronImageview.image       = Icons.chevronRight
        } else {
            collapsedConstraint.isActive = false
            expandedConstraint.isActive  = true
            chevronImageview.image       = Icons.chevronDown
        }
    }
}
