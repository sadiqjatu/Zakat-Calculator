//
//  CalculatorCardCell.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 18/05/26.
//

import UIKit

class CalculatorCardCell: UITableViewCell {
    
    static let reuseID = "CalculatorCardCell"
    let containerView  = UIView()
    let iconView       = ZCIconView()
    let titleLabel     = ZCTitleLabel(textAlignment: .natural, fontSize: 18)
    let chevronIcon   = UIImageView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureAlignment()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentView.addSubview(containerView)
        containerView.addSubviews(iconView, titleLabel, chevronIcon)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        chevronIcon.translatesAutoresizingMaskIntoConstraints  = false
        
        chevronIcon.image            = Icons.chevronRight
        chevronIcon.tintColor        = .systemGray3
        chevronIcon.contentMode      = .scaleAspectFit
        
        // Box Styling (Shadow and Rounded Corners)
        containerView.backgroundColor     = .secondarySystemGroupedBackground
        containerView.layer.cornerRadius  = 16
        containerView.layer.shadowColor   = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset  = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius  = 10
        containerView.layer.masksToBounds = false
        
        backgroundColor      = .clear
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            iconView.heightAnchor.constraint(equalToConstant: 54),
            iconView.widthAnchor.constraint(equalToConstant: 54),
            
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            chevronIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            chevronIcon.widthAnchor.constraint(equalToConstant: 15),
            chevronIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    private func configureAlignment() {
        let currentLanguage      = UserDefaults.standard.string(forKey: "selectedLanguage")
        titleLabel.textAlignment = (currentLanguage == "ar") ? .right : .left
        chevronIcon.image        = (currentLanguage == "ar") ? Icons.chevronLeft : Icons.chevronRight
    }
    
    
    func set(title: String, iconType: IconType) {
        titleLabel.text = title
        iconView.set(iconType: iconType)
    }
}
