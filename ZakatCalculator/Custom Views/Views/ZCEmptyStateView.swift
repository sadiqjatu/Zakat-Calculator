//
//  ZCEmptyStateView.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 03/06/26.
//

import UIKit

class ZCEmptyStateView: UIView {
    
    let logoImageView    = ZCIconView(backgroundColor: .systemGray5, icon: Icons.page, tintColor: .systemGray, iconSize: 54)
    let titleLabel       = ZCTitleLabel(textAlignment: .center, fontSize: 22)
    let messageLabel     = ZCSecondaryTitleLabel(textAlignment: .center, fontSize: 16)
    
    let padding: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }
    
    
    private func configure() {
        addSubviews(logoImageView, titleLabel, messageLabel)
        configureLogoImageView()
        configureTitleLabel()
        configureMessageLabel()
    }
    
    
    func configureLogoImageView() {
        logoImageView.layer.cornerRadius = 54
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -60), //add constant to adjust it to the top
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 108),
            logoImageView.heightAnchor.constraint(equalToConstant: 108),
            
            logoImageView.icon.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.icon.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    
    func configureTitleLabel() {
        titleLabel.text     = HistoryVCStrings.noCalculationsYet.localized
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    
    func configureMessageLabel() {
        messageLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            messageLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
