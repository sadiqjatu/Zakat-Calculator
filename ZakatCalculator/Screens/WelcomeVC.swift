//
//  WelcomeVC.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 16/05/26.
//

import UIKit

class WelcomeVC: UIViewController {
    
    let logoContainerView   = UIView()
    let logoImageView       = UIImageView()
    let titleLabel          = ZCTitleLabel(textAlignment: .center, fontSize: 40)
    let taglineLabel        = ZCSecondaryTitleLabel(textAlignment: .center, fontSize: 22)
    
    let featureText1        = ZCSecondaryTitleLabel(textAlignment: .left, fontSize: 20)
    let featureText2        = ZCSecondaryTitleLabel(textAlignment: .left, fontSize: 20)
    let featureText3        = ZCSecondaryTitleLabel(textAlignment: .left, fontSize: 20)
    
    let symbolImageView1     = UIImageView()
    let symbolImageView2     = UIImageView()
    let symbolImageView3     = UIImageView()
    
    let languageLabel        = ZCSecondaryTitleLabel(textAlignment: .center, fontSize: 16)
    let englishButton        = ZCLanguageButton(title: "English", languageCode: "en")
    let arabicButton         = ZCLanguageButton(title: "العربية", languageCode: "ar")
    
    var featureTextList: [ZCSecondaryTitleLabel] = []
    var symbolImageViewList: [UIImageView]       = []
    let padding: CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(logoContainerView, titleLabel, taglineLabel, symbolImageView1, symbolImageView2, symbolImageView3, featureText1, featureText2, featureText3, languageLabel, englishButton, arabicButton)
        configureViewController()
        configureLogoContainerView()
        configureTitleLabel()
        configureTaglineLabel()
        configureFeatureTextLabels()
        configureLanguageLabel()
        configureLanguageButtons()
    }
    
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
    }
    
    
    func configureLogoContainerView() {
        logoContainerView.addSubview(logoImageView)
        logoContainerView.backgroundColor    = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1)
        logoContainerView.layer.cornerRadius = 50
        logoContainerView.clipsToBounds      = true
        logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView.image                 = Images.zcLogo
        logoImageView.contentMode           = .scaleAspectFit
        logoImageView.tintColor             = .white
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        logoContainerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5) {
            self.logoContainerView.transform = .identity
        }
        
        NSLayoutConstraint.activate([
            logoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoContainerView.widthAnchor.constraint(equalToConstant: 100),
            logoContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    func configureTitleLabel() {
        titleLabel.text = "Zakat Calculator"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureTaglineLabel() {
        taglineLabel.text = "Calculate your Zakat accurately"
        
        NSLayoutConstraint.activate([
            taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            taglineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            taglineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            taglineLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    
    func configureFeatureTextLabels() {
        featureTextList = [featureText1, featureText2, featureText3]
        symbolImageViewList = [symbolImageView1, symbolImageView2, symbolImageView3]
        
        featureText1.text = "Calculate Zakat accurately"
        featureText2.text = "Track your calculations"
        featureText3.text = "Learn about Zakat"
        
        for symbolImageView in symbolImageViewList {
            symbolImageView.image           = SFSymbols.checkmark
            symbolImageView.tintColor       = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1)
            symbolImageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                symbolImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                symbolImageView.widthAnchor.constraint(equalToConstant: 30),
                symbolImageView.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        for (symbolImageView, featureText) in zip(symbolImageViewList, featureTextList) {
            
            NSLayoutConstraint.activate([
                featureText.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
                featureText.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 8),
                featureText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                featureText.heightAnchor.constraint(equalToConstant: 22)
            ])
        }
        
        NSLayoutConstraint.activate([
            symbolImageView1.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 55),

            symbolImageView2.topAnchor.constraint(equalTo: symbolImageView1.bottomAnchor, constant: 10),
            
            symbolImageView3.topAnchor.constraint(equalTo: symbolImageView2.bottomAnchor, constant: 10)
        ])
    }
    
    
    func configureLanguageLabel() {
        languageLabel.text = "Select Language"
        
        NSLayoutConstraint.activate([
            languageLabel.topAnchor.constraint(equalTo: symbolImageView3.bottomAnchor, constant: 65),
            languageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            languageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            languageLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    func configureLanguageButtons() {
        
        englishButton.addTarget(self, action: #selector(languageButtonTapped(_:)), for: .touchUpInside)
        arabicButton.addTarget(self, action: #selector(languageButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            englishButton.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 15),
            englishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            englishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            englishButton.heightAnchor.constraint(equalToConstant: 60),
            
            arabicButton.topAnchor.constraint(equalTo: englishButton.bottomAnchor, constant: 10),
            arabicButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            arabicButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            arabicButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    @objc func languageButtonTapped(_ sender: ZCLanguageButton) {
        guard let languageCode = sender.languageCode else { return }
        
        UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
        
        UserDefaults.standard.set(true, forKey: "hasOnboarded")
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            guard let window = sceneDelegate.window else { return }
            window.rootViewController = ZCTabBarController()
            
            UIView.transition(
                with: window,
                duration: 0.35,
                options: .transitionFlipFromRight,
                animations: nil
            )
        }
    }
}
