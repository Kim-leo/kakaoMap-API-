//
//  checkViewController.swift
//  kakaoMap
//
//  Created by 김승현 on 2022/02/03.
//

import UIKit
import SafariServices
import SwiftSoup


class checkViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let imagePickerController = UIImagePickerController()

    private let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()
    
    let labelArrDate: [UILabel] = {
        var labelArr = [UILabel]()
        for _ in 0...2 {
            let labels = UILabel()
            labels.textColor = .black
            labels.textAlignment = .center
            labels.backgroundColor = .white
            labels.layer.cornerRadius = 15
            labels.layer.masksToBounds = true
            labelArr.append(labels)
        }
        return labelArr
    }()
    
    let middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        stackView.layer.cornerRadius = 15
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    let labelArrNum: [UILabel] = {
        var labelArr = [UILabel]()
        for _ in 0...7 {
            let labels = UILabel()
            labels.textColor = .black
            labels.textAlignment = .center
            labels.layer.cornerRadius = 15
            labels.layer.masksToBounds = true
            labelArr.append(labels)
        }
        return labelArr
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        return stackView
    }()
    
    let cameraBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.setTitle("QR코드", for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(goToCamera(_:)), for: .touchUpInside)
        return btn
    }()
    
    let dismissBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.setTitle("나가기", for: .normal)
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(didTapDismissBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        imagePickerController.delegate = self
        crawlNum()
        
        view.addSubview(popUpView)
        PopUpViewAutoLayout()
        
        popUpView.addSubview(topStackView)
        topStackViewAutoLayout()
        for i in 0...2 {
            topStackView.addArrangedSubview(labelArrDate[i])
        }
        
        popUpView.addSubview(middleStackView)
        middleStackViewAutoLayout()
        for i in 0...7 {
            middleStackView.addArrangedSubview(labelArrNum[i])
        }
        
        popUpView.addSubview(bottomStackView)
        bottomStackViewAutoLayout()
        bottomStackView.addArrangedSubview(cameraBtn)
        bottomStackView.addArrangedSubview(dismissBtn)
        
    }
    
    func PopUpViewAutoLayout() {
        popUpView.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(250)
            make.centerX.centerY.equalToSuperview()
            
        }
    }
    
    func topStackViewAutoLayout() {
        topStackView.snp.makeConstraints { make in
            make.size.height.equalTo(45)
            make.leading.equalTo(popUpView.snp.leading).offset(5)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-5)
            make.top.equalTo(popUpView.snp.top).offset(20)
        }
    }
    
    func middleStackViewAutoLayout() {
        middleStackView.snp.makeConstraints { make in
            make.size.height.equalTo(50)
            make.leading.equalTo(popUpView.snp.leading).offset(5)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-5)
            make.centerY.equalToSuperview()
        }
    }
    
    func bottomStackViewAutoLayout() {
        bottomStackView.snp.makeConstraints { make in
            make.size.height.equalTo(40)
            make.leading.equalTo(popUpView.snp.leading).offset(15)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-15)
            make.bottom.equalTo(popUpView.snp.bottom).offset(-20)
        }
    }
    
    func crawlNum() {
        let urlString = "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=%EB%A1%9C%EB%98%90%EB%B2%88%ED%98%B8"
        guard let myurl = URL(string: urlString) else { return }
        do {
            let html = try String(contentsOf: myurl, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            let lottoTitleAndDate = try doc.select("._lotto-btn-current").select("a").text().components(separatedBy: " ")
            print(lottoTitleAndDate)
            
            
            let lottoNums = try doc.select(".num_box").select("span").text().components(separatedBy: " ")
            print(lottoNums)
            
            for i in 0...2 {
                labelArrDate[i].text = lottoTitleAndDate[i]
            }
            
            for i in 0...7 {
                labelArrNum[i].text = lottoNums[i]
            }
            labelArrNum[6].text = "+"
            
            let numberColor = [UIColor.systemYellow, UIColor.systemBlue,
                               UIColor.systemRed, UIColor.systemGray, UIColor.systemGreen]
             
            let intArr = lottoNums.compactMap { Int($0) }
            let bonusNum = lottoNums[7]
            let intBonusNum = Int(bonusNum)
            
            for i in 0...5 {
                labelArrNum[i].backgroundColor = numberColor[intArr[i]/10]
            }
            labelArrNum[6].backgroundColor = .white
            labelArrNum[7].backgroundColor = numberColor[intBonusNum!/10]
            
        } catch {
            print("Error: \(error)")
        }
        
    }
    
    @objc func didTapDismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
   
    
    @objc func goToCamera(_ sender: UIButton) {
        self.imagePickerController.sourceType = .camera
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    

}
