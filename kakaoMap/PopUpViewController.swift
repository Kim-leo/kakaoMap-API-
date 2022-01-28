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
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let label1: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.backgroundColor = .systemRed
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.layer.cornerRadius = label.frame.width/2
        label.layer.masksToBounds = true
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.backgroundColor = .systemOrange
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.layer.cornerRadius = label.frame.width/2
        label.layer.masksToBounds = true
        return label
    }()
    
    let label3: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.backgroundColor = .systemYellow
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.layer.cornerRadius = label.frame.width/2
        label.layer.masksToBounds = true
        return label
    }()
    
    let label4: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.backgroundColor = .systemGreen
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.layer.cornerRadius = label.frame.width/2
        label.layer.masksToBounds = true
        return label
    }()
    
    let label5: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.backgroundColor = .systemBlue
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.layer.cornerRadius = label.frame.width/2
        label.layer.masksToBounds = true
        return label
    }()
    
    let label6: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.backgroundColor = .systemGray
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.layer.cornerRadius = label.frame.width/2
        label.layer.masksToBounds = true
        return label
    }()
    
    let label7: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.backgroundColor = .purple
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.layer.cornerRadius = label.frame.width/2
        label.layer.masksToBounds = true
        return label
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.alpha = 0.9
        
        randomNumber()
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.addSubview(popUpView)
        PopUpViewAutoLayout()
        
        popUpView.addSubview(topStackView)
        topStackViewAutoLayout()
        
        topStackView.addArrangedSubview(label1)
        topStackView.addArrangedSubview(label2)
        topStackView.addArrangedSubview(label3)
        topStackView.addArrangedSubview(label4)
        topStackView.addArrangedSubview(label5)
        topStackView.addArrangedSubview(label6)
        topStackView.addArrangedSubview(label7)
        
        
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
        label1.text = "\(sortedNums[0])"
        label2.text = "\(sortedNums[1])"
        label3.text = "\(sortedNums[2])"
        label4.text = "\(sortedNums[3])"
        label5.text = "\(sortedNums[4])"
        label6.text = "\(sortedNums[5])"
        label7.text = "\(sortedNums[6])"
        /*
        var labelArr =  [UILabel]()
        let numberColor = [UIColor.systemYellow, UIColor.systemBlue,
                           UIColor.systemRed, UIColor.systemGray, UIColor.systemGreen]
        for labels in labelArr {
            labels.textColor = numberColor[labels.sortednum / 10]
        }
         */
        switch sortedNums[0] {
            case 1...10:
                label1.backgroundColor = .systemYellow
            case 11...20:
                label1.backgroundColor = .systemBlue
            case 21...30:
                label1.backgroundColor = .systemRed
            case 31...40:
                label1.backgroundColor = .systemGray
            default:
                label1.backgroundColor = .systemGreen
        }
        switch sortedNums[1] {
            case 1...10:
                label2.backgroundColor = .systemYellow
            case 11...20:
                label2.backgroundColor = .systemBlue
            case 21...30:
                label2.backgroundColor = .systemRed
            case 31...40:
                label2.backgroundColor = .systemGray
            default:
                label2.backgroundColor = .systemGreen
        }
        switch sortedNums[2] {
            case 1...10:
                label3.backgroundColor = .systemYellow
            case 11...20:
                label3.backgroundColor = .systemBlue
            case 21...30:
                label3.backgroundColor = .systemRed
            case 31...40:
                label3.backgroundColor = .systemGray
            default:
                label3.backgroundColor = .systemGreen
        }
        switch sortedNums[3] {
            case 1...10:
                label4.backgroundColor = .systemYellow
            case 11...20:
                label4.backgroundColor = .systemBlue
            case 21...30:
                label4.backgroundColor = .systemRed
            case 31...40:
                label4.backgroundColor = .systemGray
            default:
                label4.backgroundColor = .systemGreen
        }
        switch sortedNums[4] {
            case 1...10:
                label5.backgroundColor = .systemYellow
            case 11...20:
                label5.backgroundColor = .systemBlue
            case 21...30:
                label5.backgroundColor = .systemRed
            case 31...40:
                label5.backgroundColor = .systemGray
            default:
                label5.backgroundColor = .systemGreen
        }
        switch sortedNums[5] {
            case 1...10:
                label6.backgroundColor = .systemYellow
            case 11...20:
                label6.backgroundColor = .systemBlue
            case 21...30:
                label6.backgroundColor = .systemRed
            case 31...40:
                label6.backgroundColor = .systemGray
            default:
                label6.backgroundColor = .systemGreen
        }
        switch sortedNums[6] {
            case 1...10:
                label7.backgroundColor = .systemYellow
            case 11...20:
                label7.backgroundColor = .systemBlue
            case 21...30:
                label7.backgroundColor = .systemRed
            case 31...40:
                label7.backgroundColor = .systemGray
            default:
                label7.backgroundColor = .systemGreen
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
        label1.text = "\(sortedNums[0])"
        label2.text = "\(sortedNums[1])"
        label3.text = "\(sortedNums[2])"
        label4.text = "\(sortedNums[3])"
        label5.text = "\(sortedNums[4])"
        label6.text = "\(sortedNums[5])"
        label7.text = "\(sortedNums[6])"
        
        switch sortedNums[0] {
            case 1...10:
                label1.backgroundColor = .systemYellow
            case 11...20:
                label1.backgroundColor = .systemBlue
            case 21...30:
                label1.backgroundColor = .systemRed
            case 31...40:
                label1.backgroundColor = .systemGray
            default:
                label1.backgroundColor = .systemGreen
        }
        switch sortedNums[1] {
            case 1...10:
                label2.backgroundColor = .systemYellow
            case 11...20:
                label2.backgroundColor = .systemBlue
            case 21...30:
                label2.backgroundColor = .systemRed
            case 31...40:
                label2.backgroundColor = .systemGray
            default:
                label2.backgroundColor = .systemGreen
        }
        switch sortedNums[2] {
            case 1...10:
                label3.backgroundColor = .systemYellow
            case 11...20:
                label3.backgroundColor = .systemBlue
            case 21...30:
                label3.backgroundColor = .systemRed
            case 31...40:
                label3.backgroundColor = .systemGray
            default:
                label3.backgroundColor = .systemGreen
        }
        switch sortedNums[3] {
            case 1...10:
                label4.backgroundColor = .systemYellow
            case 11...20:
                label4.backgroundColor = .systemBlue
            case 21...30:
                label4.backgroundColor = .systemRed
            case 31...40:
                label4.backgroundColor = .systemGray
            default:
                label4.backgroundColor = .systemGreen
        }
        switch sortedNums[4] {
            case 1...10:
                label5.backgroundColor = .systemYellow
            case 11...20:
                label5.backgroundColor = .systemBlue
            case 21...30:
                label5.backgroundColor = .systemRed
            case 31...40:
                label5.backgroundColor = .systemGray
            default:
                label5.backgroundColor = .systemGreen
        }
        switch sortedNums[5] {
            case 1...10:
                label6.backgroundColor = .systemYellow
            case 11...20:
                label6.backgroundColor = .systemBlue
            case 21...30:
                label6.backgroundColor = .systemRed
            case 31...40:
                label6.backgroundColor = .systemGray
            default:
                label6.backgroundColor = .systemGreen
        }
        switch sortedNums[6] {
            case 1...10:
                label7.backgroundColor = .systemYellow
            case 11...20:
                label7.backgroundColor = .systemBlue
            case 21...30:
                label7.backgroundColor = .systemRed
            case 31...40:
                label7.backgroundColor = .systemGray
            default:
                label7.backgroundColor = .systemGreen
        }
    }
}

