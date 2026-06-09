//
//  WSCalculator.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 19/05/26.
//

import UIKit
import CoreData

class WSCalculator: UIViewController {
        
    let scrollView          = UIScrollView()
    let contentView         = UIView()
    let stackView           = UIStackView()
    
    let cashAtHomeTitle     = ZCTertiaryTitleLabel(title: WSCalculatorStrings.cashAtHome.localized, textAlignment: .natural, fontSize: 18)
    let bankAccountTitle    = ZCTertiaryTitleLabel(title: WSCalculatorStrings.bankAccounts.localized, textAlignment: .natural, fontSize: 18)
    let savingsTitle        = ZCTertiaryTitleLabel(title: WSCalculatorStrings.savings.localized, textAlignment: .natural, fontSize: 18)
    let investmentTitle     = ZCTertiaryTitleLabel(title: WSCalculatorStrings.investments.localized, textAlignment: .natural, fontSize: 18)
    let loanedMoneyTitle    = ZCTertiaryTitleLabel(title: WSCalculatorStrings.loanedMoney.localized, textAlignment: .natural, fontSize: 18)
    let assetsTitle         = ZCTertiaryTitleLabel(title: WSCalculatorStrings.assets.localized, textAlignment: .natural, fontSize: 18)
    let totalWealthTitle    = ZCTertiaryTitleLabel(title: WSCalculatorStrings.totalWealth.localized, textAlignment: .left, fontSize: 20)
    let nisabThresholdTitle = ZCTertiaryTitleLabel(title: CommonUIStrings.nisabThreshold.localized, textAlignment: .left, fontSize: 18)
    
    
    let cashAtHomeTextField  = ZCTextField(currency: "")
    let bankAccountTextField = ZCTextField(currency: "")
    let savingsTextField     = ZCTextField(currency: "")
    let investmentTextField  = ZCTextField(currency: "")
    let loanedMoneyTextField = ZCTextField(currency: "")
    let assetsTextField      = ZCTextField(currency: "")
    
    
    let totalWealthValue    = ZCTertiaryTitleLabel(title: "", textAlignment: .right, fontSize: 26)
    let nisabThresholdValue = ZCTertiaryTitleLabel(title: "", textAlignment: .right, fontSize: 22)
    let nisabInfoButton     = ZCInfoButton(message: CommonUIStrings.nisabTextInfo.localized)
    
    let resetButton          = ZCButton(backgroundColor: .systemBackground, title: CommonUIStrings.reset.localized, titleColor: .label)
    let calculateButton      = ZCButton(backgroundColor: Colors.green, title: CommonUIStrings.calculateZakat.localized, titleColor: .white)
    
    let containerViewOne     = UIView()
    let containerViewTwo     = UIView()
    let separatorLine        = UIView()
    
    var total: Double          = 0
    var nisabThreshold: Double = 0
    
    let context                = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentCurrency: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureUIElements()
        configureAlignment()
        configureContainerView()
        configureStackView()
        configureLayout()
        configureTextfieldTargets()
        configureButtonTargets()
        configureNotificationObserver()
    }
    
    
    func configureViewController() {
        view.backgroundColor                = .systemGroupedBackground
        
        let appearance                      = UINavigationBarAppearance()
        appearance.titleTextAttributes      = [ .foregroundColor: Colors.green ]
        appearance.largeTitleTextAttributes = [ .foregroundColor: Colors.green ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    func configureTextfieldTargets() {
        let textFieldList: [ZCTextField] = [cashAtHomeTextField, bankAccountTextField, savingsTextField, investmentTextField, loanedMoneyTextField, assetsTextField]
        
        for textField in textFieldList {
            textField.addTarget(self, action: #selector(calculateTotalWealth), for: .editingChanged)
        }
    }
    
    
    func configureButtonTargets() {
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        calculateButton.addTarget(self, action: #selector(calculateButtonPressed), for: .touchUpInside)
    }
    
    
    func configureUIElements() {
        let textFieldList = [cashAtHomeTextField, bankAccountTextField, savingsTextField, investmentTextField, loanedMoneyTextField, assetsTextField]
        
        for textfield in textFieldList {
            textfield.currencyLabel.text = currentCurrency
            textfield.text               = ""
        }
        
        totalWealthValue.text = currentCurrency + " 0.0"
        nisabThresholdValue.text = currentCurrency + " \(nisabThreshold.formatted(.number.grouping(.automatic).precision(.fractionLength(1))))"
    }
    
    
    func configureAlignment() {
        let labelsList = [cashAtHomeTitle, bankAccountTitle, savingsTitle, investmentTitle, loanedMoneyTitle, assetsTitle]
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage")
        
        for label in labelsList {
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
            contentView.heightAnchor.constraint(equalToConstant: 885)
        ])
    }
    
    
    func configureContainerView() {
        containerViewOne.layer.cornerRadius  = 25
        containerViewOne.layer.borderColor   = UIColor.systemGray5.cgColor
        containerViewOne.layer.borderWidth   = 1
        containerViewOne.backgroundColor     = .systemBackground
        
        containerViewTwo.layer.cornerRadius  = 25
        containerViewTwo.layer.borderColor   = UIColor.systemGray5.cgColor
        containerViewTwo.layer.borderWidth   = 1
        containerViewTwo.backgroundColor     = .systemBackground
    }
    
    
    func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(cashAtHomeTitle)
        stackView.addArrangedSubview(cashAtHomeTextField)
        stackView.addArrangedSubview(bankAccountTitle)
        stackView.addArrangedSubview(bankAccountTextField)
        stackView.addArrangedSubview(savingsTitle)
        stackView.addArrangedSubview(savingsTextField)
        stackView.addArrangedSubview(investmentTitle)
        stackView.addArrangedSubview(investmentTextField)
        stackView.addArrangedSubview(loanedMoneyTitle)
        stackView.addArrangedSubview(loanedMoneyTextField)
        stackView.addArrangedSubview(assetsTitle)
        stackView.addArrangedSubview(assetsTextField)
    }
    
    
    func configureLayout() {
        contentView.addSubviews(containerViewOne, containerViewTwo, resetButton, calculateButton)
        containerViewTwo.addSubviews(totalWealthTitle, totalWealthValue, nisabThresholdTitle, nisabThresholdValue, separatorLine, nisabInfoButton)
        
        containerViewOne.translatesAutoresizingMaskIntoConstraints   = false
        containerViewTwo.translatesAutoresizingMaskIntoConstraints   = false
        
        containerViewOne.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        separatorLine.backgroundColor = .systemGray5
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        resetButton.layer.borderWidth  = 1
        resetButton.layer.borderColor  = UIColor.white.cgColor
        
        let padding: CGFloat        = 24
        let titleHeight: CGFloat    = 20
        let textFieldHeight:CGFloat = 50
        
        NSLayoutConstraint.activate([
            containerViewOne.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            containerViewOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerViewOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerViewOne.heightAnchor.constraint(equalToConstant: 600),
            
            stackView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: containerViewOne.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: containerViewOne.bottomAnchor, constant: -padding),
            
            cashAtHomeTitle.heightAnchor.constraint(equalToConstant: titleHeight),
            bankAccountTitle.heightAnchor.constraint(equalToConstant: titleHeight),
            savingsTitle.heightAnchor.constraint(equalToConstant: titleHeight),
            investmentTitle.heightAnchor.constraint(equalToConstant: titleHeight),
            loanedMoneyTitle.heightAnchor.constraint(equalToConstant: titleHeight),
            assetsTitle.heightAnchor.constraint(equalToConstant: titleHeight),
            
            cashAtHomeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            bankAccountTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            savingsTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            investmentTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            loanedMoneyTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            assetsTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            //container view two - constraints
            containerViewTwo.topAnchor.constraint(equalTo: containerViewOne.bottomAnchor, constant: 20),
            containerViewTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerViewTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerViewTwo.heightAnchor.constraint(equalToConstant: 150),
            
            totalWealthTitle.topAnchor.constraint(equalTo: containerViewTwo.topAnchor, constant: 28),
            totalWealthTitle.leadingAnchor.constraint(equalTo: containerViewTwo.leadingAnchor, constant: 24),
            totalWealthTitle.heightAnchor.constraint(equalToConstant: 26),
            
            totalWealthValue.centerYAnchor.constraint(equalTo: totalWealthTitle.centerYAnchor),
            totalWealthValue.leadingAnchor.constraint(greaterThanOrEqualTo: totalWealthTitle.trailingAnchor, constant: 12),
            totalWealthValue.trailingAnchor.constraint(equalTo: containerViewTwo.trailingAnchor, constant: -24),
            totalWealthValue.heightAnchor.constraint(equalToConstant: 30),
            
            nisabThresholdTitle.bottomAnchor.constraint(equalTo: containerViewTwo.bottomAnchor, constant: -28),
            nisabThresholdTitle.leadingAnchor.constraint(equalTo: containerViewTwo.leadingAnchor, constant: 24),
            nisabThresholdTitle.heightAnchor.constraint(equalToConstant: 22),
            nisabThresholdTitle.trailingAnchor.constraint(equalTo: nisabInfoButton.leadingAnchor, constant: -4),
            
            nisabThresholdValue.centerYAnchor.constraint(equalTo: nisabThresholdTitle.centerYAnchor),
            nisabThresholdValue.leadingAnchor.constraint(greaterThanOrEqualTo: nisabInfoButton.trailingAnchor, constant: 12),
            nisabThresholdValue.trailingAnchor.constraint(equalTo: containerViewTwo.trailingAnchor, constant: -24),
            nisabThresholdValue.heightAnchor.constraint(equalToConstant: 24),
            
            separatorLine.centerYAnchor.constraint(equalTo: containerViewTwo.centerYAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: containerViewTwo.leadingAnchor, constant: 24),
            separatorLine.trailingAnchor.constraint(equalTo: containerViewTwo.trailingAnchor, constant: -24),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            //Reset, calcualte buttons
            resetButton.topAnchor.constraint(equalTo: containerViewTwo.bottomAnchor, constant: 20),
            resetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resetButton.heightAnchor.constraint(equalToConstant: 54),
            
            calculateButton.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor),
            calculateButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 12),
            calculateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            calculateButton.heightAnchor.constraint(equalToConstant: 54),
            
            //auto layout magic
            resetButton.widthAnchor.constraint(equalTo: calculateButton.widthAnchor),
            
            //nisab info button
            nisabInfoButton.centerYAnchor.constraint(equalTo: nisabThresholdTitle.centerYAnchor),
            nisabInfoButton.widthAnchor.constraint(equalToConstant: 30),
            nisabInfoButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    @objc func calculateTotalWealth() {
        //converth the strings into Int first
        let cash        = Double(cashAtHomeTextField.text ?? "") ?? 0
        let bank        = Double(bankAccountTextField.text ?? "") ?? 0
        let savings     = Double(savingsTextField.text ?? "") ?? 0
        let investments = Double(investmentTextField.text ?? "") ?? 0
        let loanedMoney = Double(loanedMoneyTextField.text ?? "") ?? 0
        let assets      = Double(assetsTextField.text ?? "") ?? 0
        
        //sum them up
        total           = cash + bank + savings + investments + loanedMoney + assets
        
        //update total wealth label
        totalWealthValue.text = currentCurrency + " \(total.formatted(.number.grouping(.automatic).precision(.fractionLength(2))))"
    }
    
    
    @objc func resetButtonPressed() {
        cashAtHomeTextField.text  = ""
        bankAccountTextField.text = ""
        savingsTextField.text     = ""
        investmentTextField.text  = ""
        loanedMoneyTextField.text = ""
        assetsTextField.text      = ""
        
        totalWealthValue.text     = currentCurrency + " 0"
        total                     = 0
    }
    
    
    @objc func calculateButtonPressed() {
        calculateTotalWealth()
        
        let resultVC             = ResultVC()
        resultVC.total           = total
        resultVC.nisabThreshold  = nisabThreshold
        resultVC.currentCurrency = currentCurrency
        
        saveItemToDatabase(total, nisabThreshold)
        
        let navController = UINavigationController(rootViewController: resultVC)
        present(navController, animated: true)
    }
    
    
    func saveItemToDatabase(_ total: Double, _ nisabThreshold: Double) {
        guard total >= nisabThreshold else { return }       //return immediately if total is below nisab threshold
        
        let newItem = CalculationHistory(context: context)
        
        newItem.iconString      = "cash"
        newItem.categoryString  = "wealthSavings"
        newItem.timestamp       = Date()
        newItem.totalAssets     = total
        newItem.zakatDue        = total * 0.025
        newItem.currencyCode    = currentCurrency
        
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
    }
    
    
    @objc func handleCurrencyChange() {
        fetchNisabRate()
    }
    
    
    func fetchNisabRate() {
        NetworkManager.shared.getMetalRates { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let metalData):
                self.currentCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
                let currentCurrencyValue = metalData.data.currencyRates[self.currentCurrency]!
                
                let calculateNisab  = 612.36 * metalData.data.metalPrices.XAG.price * currentCurrencyValue
                self.nisabThreshold = calculateNisab
                
                DispatchQueue.main.async {
                    self.configureUIElements()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
