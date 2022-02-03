//
//  checkViewController.swift
//  kakaoMap
//
//  Created by 김승현 on 2022/02/03.
//

import UIKit

class checkViewController: UIViewController {

    let dismissBtn: UIButton = {
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
        view.backgroundColor = .systemGreen
        
        view.addSubview(dismissBtn)
        dismissBtnAutoLayout()
        
    }
    
    func dismissBtnAutoLayout() {
        dismissBtn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.width.equalTo(150)
            make.height.equalTo(100)
        }
        
    }
    
    @objc func didTapDismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    



}
