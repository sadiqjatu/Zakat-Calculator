//
//  BACalculator.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 19/05/26.
//

import UIKit
import CoreData

class BACalculator: UIViewController {
    
    let scrollView                  = UIScrollView()
    let contentView                 = UIView()
    
    let containerViewOne 			= UIView()
    let inventoryLabel   			= ZCTertiaryTitleLabel(title: BACalculatorStrings.inventoryStock.localized, textAlignment: .natural, fontSize: 18)
    let inventoryTextfield 			= ZCTextField(currency: "")
    let cashLabel          			= ZCTertiaryTitleLabel(title: BACalculatorStrings.cashInBusiness.localized, textAlignment: .natural, fontSize: 18)
    let cashTextfield      			= ZCTextField(currency: "")
    let accountsReceivableLabel     = ZCTertiaryTitleLabel(title: BACalculatorStrings.accountsReceivable.localized, textAlignment: .natural, fontSize: 18)
    let accountsReceivableTextField = ZCTextField(currency: "")
    let rawMaterialsLabel           = ZCTertiaryTitleLabel(title: BACalculatorStrings.rawMaterials.localized, textAlignment: .natural, fontSize: 18)
    let rawMaterialsTextField       = ZCTextField(currency: "")
    let finishedGoodsLabel          = ZCTertiaryTitleLabel(title: BACalculatorStrings.finishedGoods.localized, textAlignment: .natural, fontSize: 18)
    let finishedGoodsTextField      = ZCTextField(currency: "")
    
    let stackView                   = UIStackView()
    
    let containerViewTwo            = UIView()
    let totalBusinessAssetsLabel    = ZCTertiaryTitleLabel(title: BACalculatorStrings.totalAssets.localized, textAlignment: .left, fontSize: 22)
    let totalBusinessAssetsField    = ZCTertiaryTitleLabel(title: "", textAlignment: .right, fontSize: 26)
    let nisabThresholdLabel         = ZCTertiaryTitleLabel(title: CommonUIStrings.nisabThreshold.localized, textAlignment: .left, fontSize: 20)
    let nisabThresholdField         = ZCTertiaryTitleLabel(title: "", textAlignment: .right, fontSize: 22)
    let separatorLine               = UIView()
    
    let resetButton                 = ZCButton(backgroundColor: .systemBackground, title: CommonUIStrings.reset.localized, titleColor: .label)
    let calculateButton             = ZCButton(backgroundColor: Colors.blue, title: CommonUIStrings.calculateZakat.localized, titleColor: .white)
    let nisabInfoButton             = ZCInfoButton(message: CommonUIStrings.nisabTextInfo.localized)
    
    var total: Double               = 0
    var nisabThreshold: Double      = 0
    
    let context                     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentCurrency: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureButtonTargets()
        configureTextFieldTargets()
        configureUIElements()
        configureAlignment()
        configureScrollView()
        configureStackView()
        configureContainerViewOne()
        configureContainerViewTwo()
        configureButtons()
        configureNotificationObserver()
    }
    
    
    func configureViewController() {
        view.backgroundColor                = .systemGroupedBackground
        
        let appearance                      = UINavigationBarAppearance()
        appearance.titleTextAttributes      = [.foregroundColor: Colors.blue]
        appearance.largeTitleTextAttributes = [.foregroundColor: Colors.blue]
        
        navigationController?.navigationBar.standardAppearance   = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    func configureButtonTargets() {
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        calculateButton.addTarget(self, action: #selector(calculateButtonPressed), for: .touchUpInside)
    }
    
    
    func configureTextFieldTargets() {
        let textFieldList: [ZCTextField] = [inventoryTextfield, cashTextfield, accountsReceivableTextField, rawMaterialsTextField, finishedGoodsTextField]
        
        for textField in textFieldList {
            textField.addTarget(self, action: #selector(calculateTotalAssets), for: .editingChanged)
        }
    }
    
    
    func configureUIElements() {
        let textFieldList = [inventoryTextfield, cashTextfield, accountsReceivableTextField, rawMaterialsTextField, finishedGoodsTextField]
        
        for textfield in textFieldList {
            textfield.currencyLabel.text = currentCurrency
            textfield.text               = ""
        }
        
        totalBusinessAssetsField.text = currentCurrency + " 0.0"
        nisabThresholdField.text = currentCurrency + " \(nisabThreshold.formatted(.number.grouping(.automatic).precision(.fractionLength(1))))"
    }
    
    
    func configureAlignment() {
        let labelsList = [inventoryLabel, cashLabel, accountsReceivableLabel, rawMaterialsLabel, finishedGoodsLabel]
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
            contentView.heightAnchor.constraint(equalToConstant: 785)
        ])
    }
    
    
    func configureStackView() {
        stackView.axis         = .vertical
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(inventoryLabel)
        stackView.addArrangedSubview(inventoryTextfield)
        stackView.addArrangedSubview(cashLabel)
        stackView.addArrangedSubview(cashTextfield)
        stackView.addArrangedSubview(accountsReceivableLabel)
        stackView.addArrangedSubview(accountsReceivableTextField)
        stackView.addArrangedSubview(rawMaterialsLabel)
        stackView.addArrangedSubview(rawMaterialsTextField)
        stackView.addArrangedSubview(finishedGoodsLabel)
        stackView.addArrangedSubview(finishedGoodsTextField)
    }
    
    
    func configureContainerViewOne() {
        contentView.addSubview(containerViewOne)
        containerViewOne.addSubview(stackView)
        
        containerViewOne.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints        = false
        
        containerViewOne.layer.cornerRadius     = 25
        containerViewOne.layer.borderWidth      = 1
        containerViewOne.layer.borderColor      = UIColor.systemGray5.cgColor
        containerViewOne.backgroundColor        = .systemBackground
        
        let padding: CGFloat         = 20
        let innerPadding: CGFloat    = 24
        let labelHeight: CGFloat     = 20
        let textFieldHeight: CGFloat = 50
        
        NSLayoutConstraint.activate([
            containerViewOne.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            containerViewOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerViewOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerViewOne.heightAnchor.constraint(equalToConstant: 500),
            
            stackView.topAnchor.constraint(equalTo: containerViewOne.topAnchor, constant: innerPadding),
            stackView.leadingAnchor.constraint(equalTo: containerViewOne.leadingAnchor, constant: innerPadding),
            stackView.trailingAnchor.constraint(equalTo: containerViewOne.trailingAnchor, constant: -innerPadding),
            stackView.bottomAnchor.constraint(equalTo: containerViewOne.bottomAnchor, constant: -innerPadding),
            
            inventoryLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            cashLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            accountsReceivableLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            rawMaterialsLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            finishedGoodsLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            inventoryTextfield.heightAnchor.constraint(equalToConstant: textFieldHeight),
            cashTextfield.heightAnchor.constraint(equalToConstant: textFieldHeight),
            accountsReceivableTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            rawMaterialsTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            finishedGoodsTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        ])
    }
    
    
    func configureContainerViewTwo() {
        contentView.addSubview(containerViewTwo)
        containerViewTwo.addSubviews(totalBusinessAssetsLabel, totalBusinessAssetsField, separatorLine, nisabThresholdLabel, nisabThresholdField, nisabInfoButton)
        
        
        containerViewTwo.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints    = false
        
        containerViewTwo.layer.cornerRadius = 25
        containerViewTwo.layer.borderWidth  = 1
        containerViewTwo.layer.borderColor  = UIColor.systemGray5.cgColor
        containerViewTwo.backgroundColor    = .systemBackground
        
        separatorLine.backgroundColor       = .systemGray5
        
        let padding: CGFloat         = 20
        let innerPadding: CGFloat    = 24
        let labelHeight: CGFloat     = 22
        
        NSLayoutConstraint.activate([
            containerViewTwo.topAnchor.constraint(equalTo: containerViewOne.bottomAnchor, constant: padding),
            containerViewTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerViewTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerViewTwo.heightAnchor.constraint(equalToConstant: 150),
            
            totalBusinessAssetsLabel.topAnchor.constraint(equalTo: containerViewTwo.topAnchor, constant: 28),
            totalBusinessAssetsLabel.leadingAnchor.constraint(equalTo: containerViewTwo.leadingAnchor, constant: innerPadding),
            totalBusinessAssetsLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            totalBusinessAssetsField.centerYAnchor.constraint(equalTo: totalBusinessAssetsLabel.centerYAnchor),
            totalBusinessAssetsField.leadingAnchor.constraint(greaterThanOrEqualTo: totalBusinessAssetsLabel.trailingAnchor, constant: 2),
            totalBusinessAssetsField.trailingAnchor.constraint(equalTo: containerViewTwo.trailingAnchor, constant: -innerPadding),
            totalBusinessAssetsField.heightAnchor.constraint(equalToConstant: 30),
            
            separatorLine.centerYAnchor.constraint(equalTo: containerViewTwo.centerYAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: containerViewTwo.leadingAnchor, constant: innerPadding),
            separatorLine.trailingAnchor.constraint(equalTo: containerViewTwo.trailingAnchor, constant: -innerPadding),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            nisabThresholdLabel.bottomAnchor.constraint(equalTo: containerViewTwo.bottomAnchor, constant: -28),
            nisabThresholdLabel.leadingAnchor.constraint(equalTo: containerViewTwo.leadingAnchor, constant: innerPadding),
            nisabThresholdLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            nisabThresholdField.centerYAnchor.constraint(equalTo: nisabThresholdLabel.centerYAnchor),
            nisabThresholdField.leadingAnchor.constraint(greaterThanOrEqualTo: nisabInfoButton.trailingAnchor, constant: 12),
            nisabThresholdField.trailingAnchor.constraint(equalTo: containerViewTwo.trailingAnchor, constant: -innerPadding),
            nisabThresholdField.heightAnchor.constraint(equalToConstant: 24),
            
            //nisab info button
            nisabInfoButton.centerYAnchor.constraint(equalTo: nisabThresholdLabel.centerYAnchor),
            nisabInfoButton.leadingAnchor.constraint(equalTo: nisabThresholdLabel.trailingAnchor, constant: 4),
            nisabInfoButton.heightAnchor.constraint(equalToConstant: 30),
            nisabInfoButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    func configureButtons() {
        contentView.addSubviews(resetButton, calculateButton)
        
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.white.cgColor
        
        let padding: CGFloat          = 20
        
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: containerViewTwo.bottomAnchor, constant: padding),
            resetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            resetButton.widthAnchor.constraint(equalTo: calculateButton.widthAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 54),
            
            calculateButton.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor),
            calculateButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 12),
            calculateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            calculateButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    
    @objc func calculateTotalAssets() {
        let inventory  	  = Double(inventoryTextfield.text ?? "") ?? 0
        let cash       	  = Double(cashTextfield.text ?? "") ?? 0
        let receivable 	  = Double(accountsReceivableTextField.text ?? "") ?? 0
        let rawMaterials  = Double(rawMaterialsTextField.text ?? "") ?? 0
        let finishedGoods = Double(finishedGoodsTextField.text ?? "") ?? 0
        
        total             = inventory + cash + receivable + rawMaterials + finishedGoods
        
        totalBusinessAssetsField.text = currentCurrency + " \(total.formatted(.number.grouping(.automatic).precision(.fractionLength(2))))"
    }
    
    
    @objc func resetButtonPressed() {
        inventoryTextfield.text          = ""
        cashTextfield.text               = ""
        accountsReceivableTextField.text = ""
        rawMaterialsTextField.text       = ""
        finishedGoodsTextField.text      = ""
        
        total                            = 0
        totalBusinessAssetsField.text    = currentCurrency + " 0"
    }
    
    
    @objc func calculateButtonPressed() {
        calculateTotalAssets()
        
        let resultVC             = ResultVC()
        resultVC.total           = total
        resultVC.nisabThreshold  = nisabThreshold
        resultVC.currentCurrency = currentCurrency
        
        saveItemToDatabase(total, nisabThreshold)
        
        let navController       = UINavigationController(rootViewController: resultVC)
        present(navController, animated: true)
    }
    
    
    func saveItemToDatabase(_ total: Double, _ nisabThreshold: Double) {
        guard total >= nisabThreshold else { return }
        
        let newItem  = CalculationHistory(context: context)
        
        newItem.iconString      = "business"
        newItem.categoryString  = "businessAssets"
        newItem.timestamp       = Date()
        newItem.totalAssets     = total
        newItem.zakatDue        = total * 0.025
        newItem.currencyCode    = currentCurrency
        
        do {
            try context.save()
            print("Successfully saved item into the database")
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
        fetchNisabRate()
    }
    
    
    func fetchNisabRate() {
        NetworkManager.shared.getMetalRates { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let metalData):
                self.currentCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
                let currentCurrencyValue = metalData.data.currencyRates[self.currentCurrency]!
                
                let calculateNisab = 612.36 * metalData.data.metalPrices.XAG.price * currentCurrencyValue
                self.nisabThreshold = calculateNisab
                
                DispatchQueue.main.async {
                    self.configureUIElements()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo      = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        var keyboardHeight      = keyboardFrame.cgRectValue.height
        
        var contentInsets       = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if let activeTextField = self.view.firstResponder as? UITextField {
            var rect = activeTextField.frame
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
