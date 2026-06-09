//
//  SettingsVC.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 17/05/26.
//

import UIKit

class SettingsVC: UIViewController {
    
    let scrollView               = UIScrollView()
    let contentView              = UIView()
    
    let languageContainerView    = UIView()
    let headerLanguageTitleLabel = ZCSecondaryTitleLabel(textAlignment: .natural, fontSize: 18)
    let languageTableView        = UITableView()
    let languages: [String]      = [ "English", "العربية"]
    var selectedLanguageIndex    = UserDefaults.standard.string(forKey: "selectedLanguage") == "en" ? 0 : 1
    
    
    let currencyContainerView    = UIView()
    let headerCurrencyTitleLabel = ZCSecondaryTitleLabel(textAlignment: .natural, fontSize: 18)
    var currencyCollectionView: UICollectionView!
    let currencies               = ["USD", "EUR", "GBP", "SAR", "AED", "PKR", "INR"]
    lazy var selectedCurrencyIndex: Int = {
        let savedCurrency   = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
        return currencies.firstIndex(of: savedCurrency) ?? 0
    }()
    
    let appInfoCardView = AppInfoCardView(title: SettingsVCStrings.appNameText.localized, subtitle: SettingsVCStrings.version.localized, description: SettingsVCStrings.appDescription.localized)
    
    let padding: CGFloat         = 20
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureAlignment()
        
        configureLanguageContainerView()
        configureLanguageTableView()
        
        configureCurrencyContainerView()
        configureCurrencyCollectionView()
        
        configureAppInfoCardView()
    }
    
    
    func configureViewController() {
        view.backgroundColor    = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            contentView.heightAnchor.constraint(equalToConstant: 900)
        ])
    }
    
    
    func configureAlignment() {
        let isSystemRTL      = UIView.userInterfaceLayoutDirection(for: self.languageContainerView.semanticContentAttribute) == .rightToLeft
        let currentLanguauge = UserDefaults.standard.string(forKey: "selectedLanguage")
        
        if currentLanguauge == "ar" && !isSystemRTL {
            headerLanguageTitleLabel.textAlignment = .right
            headerCurrencyTitleLabel.textAlignment = .right
        } else if currentLanguauge == "en" && isSystemRTL {
            headerLanguageTitleLabel.textAlignment = .left
            headerCurrencyTitleLabel.textAlignment = .left
        }
    }
    
    
    func configureLanguageContainerView() {
        contentView.addSubview(languageContainerView)
        
        languageContainerView.translatesAutoresizingMaskIntoConstraints = false
        languageContainerView.layer.cornerRadius  = 16
        languageContainerView.layer.shadowColor   = UIColor.black.cgColor
        languageContainerView.layer.shadowOffset  = CGSize(width: 0, height: 4)
        languageContainerView.layer.shadowOpacity = 0.05
        languageContainerView.layer.shadowRadius  = 10
        languageContainerView.layer.masksToBounds = false
        languageContainerView.backgroundColor     = .secondarySystemGroupedBackground
        
        NSLayoutConstraint.activate([
            languageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            languageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            languageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            languageContainerView.heightAnchor.constraint(equalToConstant: 172)
        ])
    }
    
    
    func configureLanguageTableView() {
        languageContainerView.addSubviews(headerLanguageTitleLabel, languageTableView)
        
        languageTableView.translatesAutoresizingMaskIntoConstraints         = false
        
        headerLanguageTitleLabel.text     = SettingsVCStrings.language.localized
        
        languageTableView.rowHeight       = 52
        languageTableView.separatorStyle  = .none
        languageTableView.backgroundColor = .clear
        languageTableView.dataSource      = self
        languageTableView.delegate        = self
        
        languageTableView.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.reuseID)
        
        NSLayoutConstraint.activate([
            headerLanguageTitleLabel.topAnchor.constraint(equalTo: languageContainerView.topAnchor, constant: 20),
            headerLanguageTitleLabel.leadingAnchor.constraint(equalTo: languageContainerView.leadingAnchor, constant: 20),
            headerLanguageTitleLabel.trailingAnchor.constraint(equalTo: languageContainerView.trailingAnchor, constant: -20),
            headerLanguageTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            languageTableView.topAnchor.constraint(equalTo: headerLanguageTitleLabel.bottomAnchor, constant: 10),
            languageTableView.leadingAnchor.constraint(equalTo: languageContainerView.leadingAnchor, constant: 10),
            languageTableView.trailingAnchor.constraint(equalTo: languageContainerView.trailingAnchor, constant: -10),
            languageTableView.bottomAnchor.constraint(equalTo: languageContainerView.bottomAnchor, constant: -10)
        ])
    }
    
    
    func configureCurrencyContainerView() {
        contentView.addSubview(currencyContainerView)
        
        currencyContainerView.translatesAutoresizingMaskIntoConstraints = false
        currencyContainerView.layer.cornerRadius  = 16
        currencyContainerView.layer.shadowColor   = UIColor.black.cgColor
        currencyContainerView.layer.shadowOpacity = 0.05
        currencyContainerView.layer.shadowOffset  = CGSize(width: 0, height: 4)
        currencyContainerView.layer.shadowRadius  = 10
        currencyContainerView.layer.masksToBounds = true
        currencyContainerView.backgroundColor     = .secondarySystemGroupedBackground
        
        NSLayoutConstraint.activate([
            currencyContainerView.topAnchor.constraint(equalTo: languageContainerView.bottomAnchor, constant: padding),
            currencyContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            currencyContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            currencyContainerView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    
    func configureCurrencyCollectionView() {
        let dynamicWidth       = view.bounds.width - (padding * 2)
        currencyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createThreeColumnFlowlayout(width: dynamicWidth))
        
        currencyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        currencyCollectionView.delegate   = self
        currencyCollectionView.dataSource = self
        currencyCollectionView.backgroundColor = .clear
        currencyCollectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.reuseID)
        
        headerCurrencyTitleLabel.text = SettingsVCStrings.currency.localized
        
        currencyContainerView.addSubviews(headerCurrencyTitleLabel, currencyCollectionView)
        
        NSLayoutConstraint.activate([
            headerCurrencyTitleLabel.topAnchor.constraint(equalTo: currencyContainerView.topAnchor, constant: 20),
            headerCurrencyTitleLabel.leadingAnchor.constraint(equalTo: currencyContainerView.leadingAnchor, constant: 20),
            headerCurrencyTitleLabel.trailingAnchor.constraint(equalTo: currencyContainerView.trailingAnchor, constant: -20),
            headerCurrencyTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            currencyCollectionView.topAnchor.constraint(equalTo: headerCurrencyTitleLabel.bottomAnchor, constant: 10),
            currencyCollectionView.leadingAnchor.constraint(equalTo: currencyContainerView.leadingAnchor, constant: 10),
            currencyCollectionView.trailingAnchor.constraint(equalTo: currencyContainerView.trailingAnchor, constant: -10),
            currencyCollectionView.bottomAnchor.constraint(equalTo: currencyContainerView.bottomAnchor, constant: -10)
        ])
    }
    
    
    func configureAppInfoCardView() {
        contentView.addSubview(appInfoCardView)

        NSLayoutConstraint.activate([
            appInfoCardView.topAnchor.constraint(equalTo: currencyContainerView.bottomAnchor, constant: padding),
            appInfoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            appInfoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            appInfoCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}


extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell     = tableView.dequeueReusableCell(withIdentifier: LanguageCell.reuseID, for: indexPath) as! LanguageCell
        
        let languageTitle = languages[indexPath.row]
        let isSelected    = selectedLanguageIndex == indexPath.row
        
        cell.set(title: languageTitle, isSelected: isSelected)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguageIndex = indexPath.row
        tableView.reloadData()
        
        let languageCode = (selectedLanguageIndex == 0) ? "en" : "ar"
        UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
        
        let isArabic = selectedLanguageIndex == 1
        let direction: UISemanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let mainWindow = windowScene.windows.first {
            
            mainWindow.semanticContentAttribute = direction
            mainWindow.rootViewController       = ZCTabBarController()
            
            UIView.transition(with: mainWindow, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}


extension SettingsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.reuseID, for: indexPath) as! CurrencyCell
        
        let currencyLabel = currencies[indexPath.item]
        let isActive      = selectedCurrencyIndex == indexPath.item
        
        cell.set(currencyLabel: currencyLabel, isActive: isActive)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCurrencyIndex = indexPath.item
        collectionView.reloadData()
        
        let currencyCode = currencies[selectedCurrencyIndex]
        UserDefaults.standard.set(currencyCode, forKey: "selectedCurrency")
        
        NotificationCenter.default.post(name: LocalizationManager.currencyChangedNotification, object: nil)
    }
}
