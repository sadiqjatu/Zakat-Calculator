//
//  ResultVC.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 20/05/26.
//

import UIKit

class ResultVC: UIViewController {
    
    let containerView       = UIView()
    let resultInfoLabel     = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 24)
    let symbolImageView     = UIImageView()
    let innerContainerView  = UIView()
    let zakatDueLabel       = ZCSecondaryTitleLabel(textAlignment: .natural, fontSize: 18)
    let zakatValueLabel     = ZCTitleLabel(textAlignment: .natural, fontSize: 55)
    let recalculateButton   = ZCButton(backgroundColor: Colors.green, title: ResultVCStrings.recalculate.localized, titleColor: .white)
    
    var total: Double!
    var nisabThreshold: Double!
    var zakatValue:Double   = 0
    
    var isEligibleForZakat: Bool {
        return total >= nisabThreshold
    }
    var currentCurrency: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        calculateZakat()
        configureUIElements()
        configureAlignment()
        configureLayout()
    }
    
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        let doneBarButton       = UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(dismissVC))
        doneBarButton.tintColor = isEligibleForZakat ? Colors.green : Colors.blue
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    
    func calculateZakat() {
        guard isEligibleForZakat else { return }
        
        zakatValue = total * 0.025
    }
    
    
    func configureUIElements() {
        containerView.translatesAutoresizingMaskIntoConstraints      = false
        
        containerView.layer.cornerRadius      = 25
        containerView.backgroundColor         = isEligibleForZakat ? Colors.green : Colors.blue
        
        symbolImageView.image                 = isEligibleForZakat ? Icons.checkmarkCircle : Icons.infoCircle
        symbolImageView.tintColor             = .white
        symbolImageView.contentMode           = .scaleAspectFit
        
        resultInfoLabel.text                  = isEligibleForZakat ? ResultVCStrings.aboveNisabThreshold.localized : ResultVCStrings.belowNisabThreshold.localized
        resultInfoLabel.textColor             = .white
        
        innerContainerView.layer.cornerRadius = 25
        innerContainerView.backgroundColor    = isEligibleForZakat ? Colors.green2 : Colors.blue2
        
        zakatDueLabel.textColor               = .white
        zakatDueLabel.text                    = ResultVCStrings.yourZakatDue.localized
        
        zakatValueLabel.text                  = currentCurrency + " \(zakatValue.formatted(.number.grouping(.automatic).precision(.fractionLength(2))))"
        zakatValueLabel.textColor             = .white
        
        recalculateButton.backgroundColor     = isEligibleForZakat ? Colors.green : Colors.blue
    }
    
    
    func configureAlignment() {
        let isSystemRTL = UIView.userInterfaceLayoutDirection(for: self.containerView.semanticContentAttribute) == .rightToLeft
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        
        if currentLanguage == "ar" && !isSystemRTL {
            resultInfoLabel.textAlignment = .right
            zakatDueLabel.textAlignment   = .right
            zakatValueLabel.textAlignment = .right
        } else if currentLanguage == "en" && isSystemRTL {
            resultInfoLabel.textAlignment = .left
            zakatDueLabel.textAlignment   = .left
            zakatValueLabel.textAlignment = .left
        }
    }
    
    
    func configureLayout() {
        view.addSubviews(containerView, recalculateButton)
        containerView.addSubviews(symbolImageView, resultInfoLabel, innerContainerView)
        innerContainerView.addSubviews(zakatDueLabel, zakatValueLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints    = false
        resultInfoLabel.translatesAutoresizingMaskIntoConstraints    = false
        innerContainerView.translatesAutoresizingMaskIntoConstraints = false
        zakatDueLabel.translatesAutoresizingMaskIntoConstraints      = false
        recalculateButton.translatesAutoresizingMaskIntoConstraints  = false
        
        recalculateButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        let padding: CGFloat      = 20
        let innerPadding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            symbolImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: innerPadding),
            symbolImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            symbolImageView.heightAnchor.constraint(equalToConstant: 40),
            symbolImageView.widthAnchor.constraint(equalToConstant: 40),
            
            resultInfoLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            resultInfoLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            resultInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            resultInfoLabel.heightAnchor.constraint(equalToConstant: 26),
            
            innerContainerView.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: innerPadding),
            innerContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: innerPadding),
            innerContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -innerPadding),
            innerContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -innerPadding),
            
            zakatDueLabel.topAnchor.constraint(equalTo: innerContainerView.topAnchor, constant: 20),
            zakatDueLabel.leadingAnchor.constraint(equalTo: innerContainerView.leadingAnchor, constant: 20),
            zakatDueLabel.trailingAnchor.constraint(equalTo: innerContainerView.trailingAnchor, constant: -20),
            zakatDueLabel.heightAnchor.constraint(equalToConstant: 20),
            
            zakatValueLabel.topAnchor.constraint(equalTo: zakatDueLabel.bottomAnchor, constant: 10),
            zakatValueLabel.leadingAnchor.constraint(equalTo: innerContainerView.leadingAnchor, constant: padding),
            zakatValueLabel.trailingAnchor.constraint(equalTo: innerContainerView.trailingAnchor, constant: -padding),
            zakatValueLabel.heightAnchor.constraint(equalToConstant: 55),
            
            recalculateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            recalculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            recalculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            recalculateButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
