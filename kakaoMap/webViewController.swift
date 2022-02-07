//
//  webViewController.swift
//  kakaoMap
//
//  Created by 김승현 on 2022/02/03.
//

import UIKit
import WebKit

class webViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var webView: WKWebView!
    
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
        
        

        
        view.addSubview(dismissBtn)
        dismissBtnAutoLayout()
    }
    
    
    func dismissBtnAutoLayout() {
        dismissBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }

    @objc func didTapDismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
 

}
