//
//  ZCTextField.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 19/05/26.
//

import UIKit

class ZCTextField: UITextField {
    
    let currencyLabel = UILabel()
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(currency: String?) {          //designated initializer
        super.init(frame: .zero)
        self.currencyLabel.text = currency
        configure()
        configureAlignment()
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius      = 18
        layer.borderWidth       = 2
        layer.borderColor       = UIColor.systemGray6.cgColor
        
        textColor               = .label
        tintColor               = .label
        textAlignment           = .natural
        
        adjustsFontSizeToFitWidth = true
        font                    = UIFont.preferredFont(forTextStyle: .body)
        minimumFontSize         = 14
        
        backgroundColor         = .tertiarySystemBackground
        keyboardType            = .numberPad
        autocorrectionType      = .no
        autocapitalizationType  = .none
        placeholder             = "0"
        
        currencyLabel.textColor = .systemGray2
        currencyLabel.font      = UIFont.preferredFont(forTextStyle: .body)
        
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let _ = currencyLabel.text else {     //return with some padding view if currencylabel.text is nil
            let paddingView = UIView()
            containerView.addSubview(paddingView)
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            
            let isSystemRTL = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
            let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
            
            if currentLanguage == "ar" && !isSystemRTL {
                textAlignment = .right
                rightView     = containerView
                rightViewMode = .always
            } else if currentLanguage == "en" && isSystemRTL {
                textAlignment = .left
                rightView     = containerView
                rightViewMode = .always
            } else if currentLanguage == "ar" && isSystemRTL {
                textAlignment = .right
                leftView     = containerView
                leftViewMode = .always
            } else {
                textAlignment = .left
                leftView      = containerView
                leftViewMode  = .always
            }
            
            NSLayoutConstraint.activate([
                containerView.widthAnchor.constraint(equalToConstant: 16),
                containerView.heightAnchor.constraint(equalToConstant: 16),
                
                paddingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                paddingView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                paddingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
            
            return
        }
        
        let isSystemRTL     = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        
        if currentLanguage == "ar" && !isSystemRTL {
            textAlignment = .right
            rightView     = containerView
            rightViewMode = .always
        } else if currentLanguage == "en" && isSystemRTL{
            textAlignment = .left
            rightView      = containerView
            rightViewMode  = .always
        } else {
            textAlignment = .natural
            leftView    = containerView
            leftViewMode = .always
        }
        
        containerView.addSubview(currencyLabel)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: 70),
            containerView.heightAnchor.constraint(equalToConstant: 34),
            
            currencyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            currencyLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            currencyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
    }
    
    
    func configureAlignment() {
        
    }
}
