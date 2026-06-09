//
//  EducationVC.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 17/05/26.
//

import UIKit

class EducationVC: UIViewController {
    
    let scrollView        = UIScrollView()
    let contentView       = UIView()
    let stackView         = UIStackView()
    
    let infoContainerView = UIView()
    let infoBodyLabel     = ZCTertiaryTitleLabel(title: EducationVCStrings.zakatInfo.localized, textAlignment: .natural, fontSize: 14)
    let infoIcon          = ZCIconView(backgroundColor: Colors.lightGreen, icon: Icons.infoCircle, tintColor: Colors.darkGreen, iconSize: 30)
    
    let zakatWhatCard     = ZCCollapsibleCardView(icon: Images.zcEducation, title: EducationVCStrings.questionOne.localized, description: EducationVCStrings.answerOne.localized)
    let zakatWhoCard      = ZCCollapsibleCardView(icon: Icons.person2, title: EducationVCStrings.questionTwo.localized, description: EducationVCStrings.answerTwo.localized)
    let nisabCard         = ZCCollapsibleCardView(icon: Icons.risingArrow, title: EducationVCStrings.questionThree.localized, description: EducationVCStrings.answerThree.localized)
    let calculationCard   = ZCCollapsibleCardView(icon: Images.zcLogo, title: EducationVCStrings.questionFour.localized, description: EducationVCStrings.answerFour.localized)
    let receivesCard      = ZCCollapsibleCardView(icon: Icons.gift, title: EducationVCStrings.questionFive.localized, description: EducationVCStrings.answerFive.localized)
    
    let padding: CGFloat      = 20
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureInfoContainerView()
        configureStackView()
    }
    
    
    func configureViewController() {
        view.backgroundColor        = .systemGroupedBackground
        
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
    
    
    func configureInfoContainerView() {
        contentView.addSubview(infoContainerView)
        infoContainerView.addSubviews(infoIcon, infoBodyLabel)
        
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        infoContainerView.layer.cornerRadius = 15
        infoContainerView.backgroundColor    = Colors.ultraLightGreen
        infoBodyLabel.textColor              = Colors.ultraDarkGreen
        infoBodyLabel.numberOfLines          = 3
        
        infoIcon.layer.cornerRadius          = 22
        
        NSLayoutConstraint.activate([
            infoContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            infoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            infoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            infoContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            infoIcon.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor),
            infoIcon.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: padding),
            infoIcon.widthAnchor.constraint(equalToConstant: 44),
            infoIcon.heightAnchor.constraint(equalToConstant: 44),
            
            infoBodyLabel.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor),
            infoBodyLabel.leadingAnchor.constraint(equalTo: infoIcon.trailingAnchor, constant: padding),
            infoBodyLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -padding)
        ])
    }
    
    
    func configureStackView() {
        stackView.axis          = .vertical
        stackView.distribution  = .equalSpacing
        stackView.spacing       = 8
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(zakatWhatCard)
        stackView.addArrangedSubview(zakatWhoCard)
        stackView.addArrangedSubview(nisabCard)
        stackView.addArrangedSubview(calculationCard)
        stackView.addArrangedSubview(receivesCard)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
            //Do not give height to the stack view, let it calculate automatically
        ])
    }
}
