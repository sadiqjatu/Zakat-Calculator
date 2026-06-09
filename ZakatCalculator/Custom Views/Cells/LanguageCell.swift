//
//  LanguageCell.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 05/06/26.
//

import UIKit

class LanguageCell: UITableViewCell {
    
    static let reuseID      = "languageCell"
    let languageLabel       = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 16)
    let checkmarkImageView  = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentView.addSubviews(languageLabel, checkmarkImageView)
        
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        checkmarkImageView.image       = Icons.checkmark
        checkmarkImageView.tintColor   = Colors.green
        checkmarkImageView.contentMode = .scaleAspectFit
        
        backgroundColor                = .clear   
        
        NSLayoutConstraint.activate([
            languageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            languageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            languageLabel.heightAnchor.constraint(equalToConstant: 18),
            
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    func set(title: String, isSelected: Bool) {
        languageLabel.text          = title
        checkmarkImageView.isHidden = !isSelected
    }
}
