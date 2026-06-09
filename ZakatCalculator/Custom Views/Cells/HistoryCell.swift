//
//  HistoryCell.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 28/05/26.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let reuseId     = "historyCell"
    let containerView      = UIView()
    let iconView   		   = ZCIconView()
    let titleLabel 		   = ZCTitleLabel(textAlignment: .natural, fontSize: 18)
    let date       		   = ZCSecondaryTitleLabel(textAlignment: .natural, fontSize: 12)
    let trashIcon  		   = ZCIconView(backgroundColor: .systemBackground, icon: Icons.trash, tintColor: .systemGray3, iconSize: 30)
    let totalAssetsLabel   = ZCTertiaryTitleLabel(title: "totalAssets".localized, textAlignment: .natural, fontSize: 14)
    let totalAssetsValue   = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 16)
    let zakatDueLabel      = ZCTertiaryTitleLabel(title: "zakatDue".localized, textAlignment: .natural, fontSize: 14)
    let zakatDueValue      = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 18)
    
    var onDeleteButtonTapped: (() -> Void)?
    var currentCurrency    = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureUIElements()
        configureTrashButton()
        configureAlignment()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureTrashButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(trashIconPressed))
        trashIcon.addGestureRecognizer(tap)
    }
    
    
    private func configure() {
        contentView.addSubview(containerView)
        containerView.addSubviews(iconView, titleLabel, date, trashIcon, totalAssetsLabel, totalAssetsValue, zakatDueLabel, zakatDueValue)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Box Styling (Shadow and Rounded Corners)
        containerView.backgroundColor = .secondarySystemGroupedBackground
        containerView.layer.cornerRadius =  16
        containerView.layer.shadowColor  = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset  = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius  = 10
        containerView.layer.masksToBounds = false
        
        zakatDueValue.textColor = Colors.darkGreen
        iconView.layer.cornerRadius  = 22
        trashIcon.layer.cornerRadius = 0
        trashIcon.isUserInteractionEnabled = true
        
        backgroundColor = .clear
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            iconView.heightAnchor.constraint(equalToConstant: 44),
            iconView.widthAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            trashIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            trashIcon.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 10),
            trashIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            trashIcon.heightAnchor.constraint(equalToConstant: 20),
            trashIcon.widthAnchor.constraint(equalToConstant: 20),
            
            trashIcon.icon.heightAnchor.constraint(equalToConstant: 20),
            trashIcon.icon.widthAnchor.constraint(equalToConstant: 20),
            
            date.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            date.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            date.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            date.heightAnchor.constraint(equalToConstant: 14),
            
            totalAssetsLabel.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10),
            totalAssetsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            totalAssetsLabel.heightAnchor.constraint(equalToConstant: 16),
            
            totalAssetsValue.centerYAnchor.constraint(equalTo: totalAssetsLabel.centerYAnchor),
            totalAssetsValue.leadingAnchor.constraint(greaterThanOrEqualTo: totalAssetsLabel.trailingAnchor, constant: 10),
            totalAssetsValue.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            totalAssetsValue.heightAnchor.constraint(equalToConstant: 18),
            
            zakatDueLabel.topAnchor.constraint(equalTo: totalAssetsLabel.bottomAnchor, constant: 10),
            zakatDueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            zakatDueLabel.heightAnchor.constraint(equalToConstant: 16),
            
            zakatDueValue.centerYAnchor.constraint(equalTo: zakatDueLabel.centerYAnchor),
            zakatDueValue.leadingAnchor.constraint(greaterThanOrEqualTo: zakatDueLabel.trailingAnchor, constant: 10),
            zakatDueValue.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            zakatDueValue.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    private func configureUIElements() {
        totalAssetsValue.text = currentCurrency + " 0"
        zakatDueValue.text    = currentCurrency + " 0"
    }
    
    
    private func configureAlignment() {
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        
        date.textAlignment  = (currentLanguage == "ar") ? .right : .left
    }
    
    
    func set(categoryString: String, iconType: IconType, timestamp: Date, totalAssets: Double, zakatDue: Double, currentCurrency: String) {
        titleLabel.text = categoryString.localized
        iconView.set(iconType: iconType)
        self.date.text = "\(timestamp.convertToMonthDateYearTimeFormat())"
        totalAssetsValue.text = currentCurrency + " \(totalAssets.formatted(.number.grouping(.automatic).precision(.fractionLength(2))))"
        zakatDueValue.text    = currentCurrency + " \(zakatDue.formatted(.number.grouping(.automatic).precision(.fractionLength(2))))"
    }
    
    
    @objc func trashIconPressed() {
        onDeleteButtonTapped?()
    }
}
