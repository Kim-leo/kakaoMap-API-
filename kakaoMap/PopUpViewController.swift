//
//  PopUpViewController.swift
//  kakaoMap RandomNumber
//
//  Created by 김승현 on 2022/01/27.
//

import UIKit

final class PopUpViewController: UIViewController {
    
    var numbers: [Int] = []
    
    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let anotherNumbersBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.setTitle("다른 번호", for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(anotherNumbers(_:)), for: .touchUpInside)
        return btn
    }()
    
    private let dismissBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.setTitle("나가기", for: .normal)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(didTapDismissBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    let labelArr: [UILabel] = {
        var labelArr = [UILabel]()
        
        for _ in 0...5 {
            let labels = UILabel()
            
            labels.textColor = .black
            labels.textAlignment = .center
            labels.layer.cornerRadius = 15
            labels.layer.masksToBounds = true
            labelArr.append(labels)
        }
        
        return labelArr
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomNumber()
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        view.addSubview(popUpView)
        PopUpViewAutoLayout()
        
        popUpView.addSubview(topStackView)
        topStackViewAutoLayout()
        
        for i in 0...5 {
            topStackView.addArrangedSubview(labelArr[i])
        }
        
        
        popUpView.addSubview(bottomStackView)
        bottomStackViewAutoLayout()
  
        bottomStackView.addArrangedSubview(anotherNumbersBtn)
        bottomStackView.addArrangedSubview(dismissBtn)
    }
    
    func randomNumber() {
        while numbers.count < 7 {
            let number = Int.random(in: 1...45)
            if !numbers.contains(number) {
                numbers.append(number)
            }
        }
        
        let sortedNums = numbers.sorted()
        for i in 0...5 {
            labelArr[i].text = "\(sortedNums[i])"
        }
        
        let numberColor = [UIColor.systemYellow, UIColor.systemBlue,
                           UIColor.systemRed, UIColor.systemGray, UIColor.systemGreen]
        for i in 0...5 {
            labelArr[i].backgroundColor = numberColor[sortedNums[i]/10]
        }
    }

    func PopUpViewAutoLayout() {
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popUpView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        popUpView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func topStackViewAutoLayout() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 5).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -5).isActive = true
        topStackView.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 15).isActive = true
    }
    
    func bottomStackViewAutoLayout() {
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 5).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -5).isActive = true
        bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 25).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func didTapDismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func anotherNumbers(_ sender: UIButton) {
        
        
        var numbers: [Int] = []
        
        while numbers.count < 7 {
            let number = Int.random(in: 1...45)
            if !numbers.contains(number) {
                numbers.append(number)
            }
        }
        
        let sortedNums = numbers.sorted()
        
        for i in 0...5 {
            labelArr[i].text = "\(sortedNums[i])"
        }
        
        let numberColor = [UIColor.systemYellow, UIColor.systemBlue,
                           UIColor.systemRed, UIColor.systemGray, UIColor.systemGreen]
        for i in 0...5 {
            labelArr[i].backgroundColor = numberColor[sortedNums[i]/10]
        }
        
        
    }
}

