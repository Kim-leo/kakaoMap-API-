//
//  ViewController.swift
//  kakaoMap
//
//  Created by 김승현 on 2021/12/31.
//

import UIKit

class ViewController: UIViewController, MTMapViewDelegate {

    var mapView: MTMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MTMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
         
    }


}

