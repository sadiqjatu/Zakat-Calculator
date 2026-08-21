//
//  GSCalculator.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 19/05/26.
//

import UIKit
import CoreData

class GSCalculator: UIViewController {
    
    let scrollView       = UIScrollView()
    let contentView      = UIView()
    
    let containerViewOne    = UIView()
    let currentPricesLabel  = ZCTertiaryTitleLabel(title: GSCalculatorStrings.currentPrices.localized, textAlignment: .left, fontSize: 20)
    let refreshIcon         = UIImageView()
    
    let containerViewTwo    = UIView()
    let goldLabel           = ZCTertiaryTitleLabel(title: GSCalculatorStrings.gold.localized, textAlignment: .natural, fontSize: 18)
    let goldAmountLabel     = ZCTertiaryTitleLabel(title: GSCalculatorStrings.goldAmount.localized, textAlignment: .natural, fontSize: 18)
    let goldAmountTextField = ZCTextField(currency: nil)
    let goldPriceLabel      = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 18)
    let goldPriceTextField  = ZCTextField(currency: nil)
    
    let goldContainerView   = UIView()
    let goldValueLabel      = ZCTertiaryTitleLabel(title: GSCalculatorStrings.goldValue.localized, textAlignment: .natural, fontSize: 18)
    let goldValueField      = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 22)
    
    let separatorLine       = UIView()
    let silverLabel         = ZCTertiaryTitleLabel(title: GSCalculatorStrings.silver.localized, textAlignment: .natural, fontSize: 18)
    let silverAmountLabel   = ZCTertiaryTitleLabel(title: GSCalculatorStrings.silverAmount.localized, textAlignment: .natural, fontSize: 18)
    let silverAmountTextField = ZCTextField(currency: nil)
    let silverPriceLabel    = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 18)
    let silverPriceTextField = ZCTextField(currency: nil)
    
    let silverContainerView = UIView()
    let silverValueLabel    = ZCTertiaryTitleLabel(title: GSCalculatorStrings.silverValue.localized, textAlignment: .natural, fontSize: 18)
    let silverValueField    = ZCTertiaryTitleLabel(title: "", textAlignment: .natural, fontSize: 22)
    
    let stackView           = UIStackView()
    
    let containerViewThree  = UIView()
    let totalValueLabel     = ZCTertiaryTitleLabel(title: GSCalculatorStrings.totalValue.localized, textAlignment: .left, fontSize: 20)
    let totalValueField     = ZCTertiaryTitleLabel(title: "", textAlignment: .right, fontSize: 26)
    let nisabThresholdLabel = ZCTertiaryTitleLabel(title: CommonUIStrings.nisabThreshold.localized, textAlignment: .left, fontSize: 18)
    let nisabThresholdField = ZCTertiaryTitleLabel(title: "", textAlignment: .right, fontSize: 22)
    let separatorLineTwo    = UIView()
    
    let resetButton         = ZCButton(backgroundColor: .systemBackground, title: CommonUIStrings.reset.localized, titleColor: .label)
    let calculateButton     = ZCButton(backgroundColor: Colors.amber, title: CommonUIStrings.calculateZakat.localized, titleColor: .white)
    let nisabInfoButton     = ZCInfoButton(message: CommonUIStrings.nisabTextInfo.localized)
    
    var total: Double          = 0
    var nisabThreshold: Double = 0
    var goldPrice: Double      = 0
    var silverPrice: Double    = 0
    
    let context                = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentCurrency: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureTextFieldTargets()
        configureButtonTargets()
        configureUIElements()
        configureAlignment()
        
        configureStackView()
        configureContainerViewOne()
        configureContainerViewTwo()
        configureContainerViewThree()
        configureButtons()
        
        configureNotificationObserver()
    }
    
    
    func configureViewController() {
        view.backgroundColor                = .systemGroupedBackground
        
        let appearance                      = UINavigationBarAppearance()
        appearance.titleTextAttributes      = [ .foregroundColor: Colors.amber ]
        appearance.largeTitleTextAttributes = [ .foregroundColor: Colors.amber ]
        
        navigationController?.navigationBar.standardAppearance   = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    func configureTextFieldTargets() {
        let textFieldList: [ZCTextField] = [goldAmountTextField, goldPriceTextField, silverAmountTextField, silverPriceTextField]
        
        for textField in textFieldList {
            textField.addTarget(self, action: #selector(calculcateTotalValue), for: .editingChanged)
        }
    }
    
    
    func configureButtonTargets() {
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        calculateButton.addTarget(self, action: #selector(calculateButtonPressed), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(refetchMetalData))
        refreshIcon.addGestureRecognizer(tap)
    }
    
    
    func configureUIElements() {
        goldPriceLabel.text       = String(format: GSCalculatorStrings.goldPricePerGram.localized, currentCurrency)
        goldAmountTextField.text  = ""
        goldValueField.text       = String(format: "%@ 0", currentCurrency)
        
        silverPriceLabel.text      = String(format: GSCalculatorStrings.silverPricePerGram.localized, currentCurrency)
        silverAmountTextField.text = ""
        silverValueField.text      = String(format: "%@ 0", currentCurrency)
        
        totalValueField.text       = String(format: "%@ 0", currentCurrency)
        
        nisabThresholdField.text  = String(format: "%@ \(nisabThreshold.formatted(.number.grouping(.automatic).precision(.fractionLength(1))))", currentCurrency)
        goldPriceTextField.text   = "\(goldPrice.formatted(.number.grouping(.automatic).precision(.fractionLength(2))))"
        silverPriceTextField.text = "\(silverPrice.formatted(.number.grouping(.automatic).precision(.fractionLength(2))))"
        
        goldPriceTextField.isUserInteractionEnabled   = false
        silverPriceTextField.isUserInteractionEnabled = false
    }
    
    
    func configureAlignment() {
        let labelList = [goldLabel, goldAmountLabel, goldPriceLabel, silverLabel, silverAmountLabel, silverPriceLabel]
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        
        for label in labelList {
            label.textAlignment = (currentLanguage == "ar") ? .right : .left
        }
    }
    
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1075)
        ])
    }
    
    
    func configureStackView() {
        stackView.axis          = .vertical
        stackView.distribution  = .equalSpacing
        
        stackView.addArrangedSubview(goldLabel)
        stackView.addArrangedSubview(goldAmountLabel)
        stackView.addArrangedSubview(goldAmountTextField)
        stackView.addArrangedSubview(goldPriceLabel)
        stackView.addArrangedSubview(goldPriceTextField)
        stackView.addArrangedSubview(goldContainerView)
        
        stackView.addArrangedSubview(separatorLine)
        
        stackView.addArrangedSubview(silverLabel)
        stackView.addArrangedSubview(silverAmountLabel)
        stackView.addArrangedSubview(silverAmountTextField)
        stackView.addArrangedSubview(silverPriceLabel)
        stackView.addArrangedSubview(silverPriceTextField)
        stackView.addArrangedSubview(silverContainerView)
    }
    
    
    func configureContainerViewOne() {
        contentView.addSubview(containerViewOne)
        containerViewOne.addSubviews(currentPricesLabel, refreshIcon)
        
        containerViewOne.translatesAutoresizingMaskIntoConstraints = false
        refreshIcon.translatesAutoresizingMaskIntoConstraints  = false
        
        containerViewOne.layer.cornerRadius = 16
        containerViewOne.backgroundColor    = Colors.lightGold
        
        currentPricesLabel.textColor        = Colors.darkGold
        refreshIcon.contentMode         = .scaleAspectFit
        refreshIcon.image               = Icons.refresh
        refreshIcon.tintColor           = Colors.darkGold
        refreshIcon.backgroundColor     = Colors.lightAmber
        refreshIcon.layer.cornerRadius  = 8
        refreshIcon.isUserInteractionEnabled = true
        
        let padding: CGFloat      = 20
        let innerPadding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            containerViewOne.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            containerViewOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerViewOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerViewOne.heightAnchor.constraint(equalToConstant: 60),
            
            currentPricesLabel.centerYAnchor.constraint(equalTo: containerViewOne.centerYAnchor),
            currentPricesLabel.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: innerPadding),
            currentPricesLabel.heightAnchor.constraint(equalToConstant: 22),
            
            refreshIcon.centerYAnchor.constraint(equalTo: currentPricesLabel.centerYAnchor),
            refreshIcon.trailingAnchor.constraint(equalTo: containerViewOne.trailingAnchor, constant: -innerPadding),
            refreshIcon.heightAnchor.constraint(equalToConstant: 25),
            refreshIcon.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    
    func configureContainerViewTwo() {
        contentView.addSubview(containerViewTwo)
        containerViewTwo.addSubview(stackView)
        goldContainerView.addSubviews(goldValueLabel, goldValueField)
        silverContainerView.addSubviews(silverValueLabel, silverValueField)
        
        containerViewTwo.translatesAutoresizingMaskIntoConstraints    = false
        goldContainerView.translatesAutoresizingMaskIntoConstraints   = false
        stackView.translatesAutoresizingMaskIntoConstraints           = false
        separatorLine.translatesAutoresizingMaskIntoConstraints       = false
        silverContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerViewTwo.layer.cornerRadius = 25
        containerViewTwo.layer.borderColor  = UIColor.systemGray5.cgColor
        containerViewTwo.layer.borderWidth  = 1
        containerViewTwo.backgroundColor    = .systemBackground
        
        goldLabel.textColor = Colors.amber
        
        goldContainerView.layer.cornerRadius = 16
        goldContainerView.backgroundColor    = Colors.lightGold
        goldValueLabel.textColor             = Colors.amber
        goldValueField.textColor             = Colors.darkGold
        
        separatorLine.backgroundColor        = .systemGray5
        
        silverContainerView.layer.cornerRadius = 16
        silverContainerView.backgroundColor    = Colors.silver
        
        let padding: CGFloat         = 20
        let innerPadding: CGFloat    = 24
        let labelHeight: CGFloat     = 20
        let textFieldHeight: CGFloat = 50
        
        NSLayoutConstraint.activate([
            containerViewTwo.topAnchor.constraint(equalTo: containerViewOne.bottomAnchor, constant: padding),
            containerViewTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerViewTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerViewTwo.heightAnchor.constraint(equalToConstant: 710),
            
            stackView.topAnchor.constraint(equalTo: containerViewTwo.topAnchor, constant: innerPadding),
            stackView.leadingAnchor.constraint(equalTo: containerViewTwo.leadingAnchor, constant: innerPadding),
            stackView.trailingAnchor.constraint(equalTo: containerViewTwo.trailingAnchor, constant: -innerPadding),
            stackView.bottomAnchor.constraint(equalTo: containerViewTwo.bottomAnchor, constant: -innerPadding),
            
            goldLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            goldAmountLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            goldPriceLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            silverLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            silverAmountLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            silverPriceLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            goldAmountTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            goldPriceTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            goldContainerView.heightAnchor.constraint(equalToConstant: textFieldHeight),
            silverAmountTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            silverPriceTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            silverContainerView.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            //gold container view
            goldValueLabel.centerYAnchor.constraint(equalTo: goldContainerView.centerYAnchor),
            goldValueLabel.leadingAnchor.constraint(equalTo: goldContainerView.leadingAnchor, constant: 8),
            goldValueLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            goldValueField.centerYAnchor.constraint(equalTo: goldValueLabel.centerYAnchor),
            goldValueField.leadingAnchor.constraint(equalTo: goldValueLabel.trailingAnchor, constant: 2),
            goldValueField.trailingAnchor.constraint(lessThanOrEqualTo: goldContainerView.trailingAnchor, constant: -8),
            goldValueField.heightAnchor.constraint(equalToConstant: 24),
            
            //silver container view
            silverValueLabel.centerYAnchor.constraint(equalTo: silverContainerView.centerYAnchor),
            silverValueLabel.leadingAnchor.constraint(equalTo: silverContainerView.leadingAnchor, constant: 8),
            silverValueLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            silverValueField.centerYAnchor.constraint(equalTo: silverValueLabel.centerYAnchor),
            silverValueField.leadingAnchor.constraint(equalTo: silverValueLabel.trailingAnchor, constant: 2),
            silverValueField.trailingAnchor.constraint(lessThanOrEqualTo: silverContainerView.trailingAnchor, constant: -8),
            silverValueField.heightAnchor.constraint(equalToConstant: 24),
            
            //separator line
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.topAnchor.constraint(equalTo: goldContainerView.bottomAnchor, constant: 20),
            separatorLine.bottomAnchor.constraint(equalTo: silverLabel.topAnchor, constant: -20)
        ])
    }
    
    
    func configureContainerViewThree() {
        contentView.addSubview(containerViewThree)
        containerViewThree.addSubviews(totalValueLabel, totalValueField, separatorLineTwo, nisabThresholdLabel, nisabThresholdField, nisabInfoButton)
        
        containerViewThree.translatesAutoresizingMaskIntoConstraints = false
        separatorLineTwo.translatesAutoresizingMaskIntoConstraints   = false
        
        containerViewThree.layer.cornerRadius  = 25
        containerViewThree.layer.borderColor   = UIColor.systemGray5.cgColor
        containerViewThree.layer.borderWidth   = 1
        containerViewThree.backgroundColor     = .systemBackground
        
        separatorLineTwo.backgroundColor       = .systemGray5
        
        let padding: CGFloat      = 20
        let innerPadding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            containerViewThree.topAnchor.constraint(equalTo: containerViewTwo.bottomAnchor, constant: padding),
            containerViewThree.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerViewThree.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerViewThree.heightAnchor.constraint(equalToConstant: 150),
            
            totalValueLabel.topAnchor.constraint(equalTo: containerViewThree.topAnchor, constant: innerPadding),
            totalValueLabel.leadingAnchor.constraint(equalTo: containerViewThree.leadingAnchor, constant: innerPadding),
            totalValueLabel.heightAnchor.constraint(equalToConstant: 26),
            
            totalValueField.centerYAnchor.constraint(equalTo: totalValueLabel.centerYAnchor),
            totalValueField.leadingAnchor.constraint(greaterThanOrEqualTo: totalValueLabel.trailingAnchor, constant: 12),
            totalValueField.trailingAnchor.constraint(equalTo: containerViewThree.trailingAnchor, constant: -innerPadding),
            totalValueField.heightAnchor.constraint(equalToConstant: 30),
            
            separatorLineTwo.centerYAnchor.constraint(equalTo: containerViewThree.centerYAnchor),
            separatorLineTwo.leadingAnchor.constraint(equalTo: containerViewThree.leadingAnchor, constant: innerPadding),
            separatorLineTwo.trailingAnchor.constraint(equalTo: containerViewThree.trailingAnchor, constant: -innerPadding),
            separatorLineTwo.heightAnchor.constraint(equalToConstant: 1),
            
            nisabThresholdLabel.bottomAnchor.constraint(equalTo: containerViewThree.bottomAnchor, constant: -innerPadding),
            nisabThresholdLabel.leadingAnchor.constraint(equalTo: containerViewThree.leadingAnchor, constant: innerPadding),
            nisabThresholdLabel.heightAnchor.constraint(equalToConstant: 22),
            nisabThresholdLabel.trailingAnchor.constraint(equalTo: nisabInfoButton.leadingAnchor, constant: -4),
            
            nisabThresholdField.centerYAnchor.constraint(equalTo: nisabThresholdLabel.centerYAnchor),
            nisabThresholdField.leadingAnchor.constraint(greaterThanOrEqualTo: nisabInfoButton.trailingAnchor, constant: 12),
            nisabThresholdField.trailingAnchor.constraint(equalTo: containerViewThree.trailingAnchor, constant: -innerPadding),
            nisabThresholdField.heightAnchor.constraint(equalToConstant: 24),
            
            //setting up nisab info button
            nisabInfoButton.centerYAnchor.constraint(equalTo: nisabThresholdLabel.centerYAnchor),
//            nisabInfoButton.leadingAnchor.constraint(equalTo: nisabThresholdLabel.trailingAnchor, constant: 4),
            nisabInfoButton.widthAnchor.constraint(equalToConstant: 30),
            nisabInfoButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    func configureButtons() {
        contentView.addSubviews(resetButton, calculateButton)
        
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.white.cgColor
        
        let padding: CGFloat    = 20
        
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: containerViewThree.bottomAnchor, constant: padding),
            resetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            resetButton.widthAnchor.constraint(equalTo: calculateButton.widthAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 54),
            
            calculateButton.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor),
            calculateButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 12),
            calculateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            calculateButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    
    @objc func calculcateTotalValue() {
        //Get input from amount and price text field
        let goldAmount      = Double(goldAmountTextField.text ?? "") ?? 0
        let goldPrice       = self.goldPrice
        
        let silverAmount    = Double(silverAmountTextField.text ?? "") ?? 0
        let silverPrice     = self.silverPrice
        
        let goldValue            = goldAmount * goldPrice
        let silverValue          = silverAmount * silverPrice
        total                    = goldValue + silverValue
         
        let goldFormattedValue   = goldValue.formatted(.number.grouping(.automatic).precision(.fractionLength(2)))
        let silverFormattedValue = silverValue.formatted(.number.grouping(.automatic).precision(.fractionLength(2)))
        let totalFormattedValue  = total.formatted(.number.grouping(.automatic).precision(.fractionLength(2)))
        
        goldValueField.text   = String(format: "%@ \(goldFormattedValue)", currentCurrency)
        silverValueField.text = String(format: "%@ \(silverFormattedValue)", currentCurrency)
        totalValueField.text  = String(format: "%@ \(totalFormattedValue)", currentCurrency)
    }
    
    
    @objc func resetButtonPressed() {
        goldAmountTextField.text   = ""
        goldValueField.text        = String(format: "%@ 0", currentCurrency)
        silverAmountTextField.text = ""
        silverValueField.text      = String(format: "%@ 0", currentCurrency)
        
        totalValueField.text       = String(format: "%@ 0", currentCurrency)
        total                      = 0
    }
    
    
    @objc func calculateButtonPressed() {
        calculcateTotalValue()
        
        let resultVC             = ResultVC()
        resultVC.nisabThreshold  = nisabThreshold
        resultVC.total           = total
        resultVC.currentCurrency = currentCurrency
        
        
        
        saveItemToDatabase(total, nisabThreshold)
        
        let navController       = UINavigationController(rootViewController: resultVC)
        present(navController, animated: true)
    }
    
    
    @objc func refetchMetalData() {
        DispatchQueue.main.async {
            NetworkManager.shared.getMetalRates { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let metalData):
                    self.goldPriceTextField.text   = "\(metalData.data.metalPrices.XAU.price)"
                    self.silverPriceTextField.text = "\(metalData.data.metalPrices.XAG.price)"
                case .failure(let error):
                    print("DEBUG: error fetching metal values: \(error)")
                }
            }
        }
    }
    
    
    func saveItemToDatabase(_ total: Double, _ nisabThreshold: Double) {
        guard total >= nisabThreshold else { return }       // return immediately if total is below nisabThreshold
        
        let newItem  = CalculationHistory(context: context)
        
        newItem.iconString = "gold"
        newItem.categoryString = "goldSilver"
        newItem.timestamp      = Date()
        newItem.totalAssets    = total
        newItem.zakatDue       = total * 0.025
        newItem.currencyCode   = currentCurrency
        
        do {
            try context.save()
            print("Successfully saved the item into the core data database.")
        } catch {
            print("Error saving item into the database: \(error.localizedDescription)")
        }
    }
    
    
    func configureNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCurrencyChange),
            name: LocalizationManager.currencyChangedNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func handleCurrencyChange() {
        fetchMetalRates()
    }
    
    
    func fetchMetalRates() {
        NetworkManager.shared.getMetalRates { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let metalData):
                    self.currentCurrency     = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
                    let currentCurrencyValue = metalData.data.currencyRates[self.currentCurrency] ?? 1.0
                    
                    self.nisabThreshold      = 612.36 * metalData.data.metalPrices.XAG.price * currentCurrencyValue
                    
                    self.goldPrice           = metalData.data.metalPrices.XAU.price * currentCurrencyValue
                    self.silverPrice         = metalData.data.metalPrices.XAG.price * currentCurrencyValue
                    
                    DispatchQueue.main.async {
                        self.configureUIElements()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo      = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight      = keyboardFrame.cgRectValue.height
        
        let contentInsets       = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if let activeTextField = self.view.firstResponder as? UITextField {
            let convertedFrame = scrollView.convert(activeTextField.bounds, from: activeTextField)
            
            var rect = convertedFrame
            rect.size.height += 20
            
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    
    @objc func keyboardWillHide() {
        let contentInsets                = UIEdgeInsets.zero
        scrollView.contentInset          = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
