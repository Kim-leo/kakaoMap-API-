//
//  ViewController.swift
//  kakaoMap
//
//  Created by 김승현 on 2021/12/31.
//

import UIKit

public let defaultPosition = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)

class ViewController: UIViewController, MTMapViewDelegate {
    
    public let stackView = UIStackView()
    
    public let btn1 = UIButton()
    public let btn2 = UIButton()
    public let btn3 = UIButton()
    public let btn4 = UIButton()
    
    public let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 50))

    var mapView: MTMapView!
    
    var mapPoint1: MTMapPoint!
    var poilItem1: MTMapPOIItem?
    
    //검색기능
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MTMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        
        //지도 중심점, 레벨
        mapView.setMapCenter(MTMapPoint(geoCoord: defaultPosition), animated: true)
        
        //현재 위치 트래킹
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithHeading
        
        //마커 추가
        self.mapPoint1 = MTMapPoint(geoCoord: defaultPosition)
        poilItem1 = MTMapPOIItem()
        poilItem1?.markerType = MTMapPOIItemMarkerType.redPin
        poilItem1?.mapPoint = mapPoint1
        poilItem1?.itemName = "현재 위치"
        mapView.add(poilItem1)
        
        self.view.addSubview(mapView)
        
        //검색기능
        navigationItem.searchController = searchController
        
        //스택뷰와 버튼 4개
        btn1.backgroundColor = .lightGray
        btn1.setTitle("test 1", for: .normal)
        btn1.addTarget(self, action: #selector(btn1Action), for: .touchUpInside)
        btn1.translatesAutoresizingMaskIntoConstraints = false
        btn1.layer.cornerRadius = 10
        
        btn2.backgroundColor = .black
        btn2.setTitle("test 2", for: .normal)
        btn2.addTarget(self, action: #selector(btn2Action), for: .touchUpInside)
        btn2.translatesAutoresizingMaskIntoConstraints = false
        btn2.layer.cornerRadius = 10
        
        btn3.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 1, alpha: 1)
        btn3.setTitle("test 3", for: .normal)
        btn3.addTarget(self, action: #selector(btn3Action), for: .touchUpInside)
        btn3.translatesAutoresizingMaskIntoConstraints = false
        btn3.layer.cornerRadius = 10
        
        btn4.backgroundColor = .systemIndigo
        btn4.setTitle("test 4", for: .normal)
        btn4.addTarget(self, action: #selector(btn4Action), for: .touchUpInside)
        btn4.translatesAutoresizingMaskIntoConstraints = false
        btn4.layer.cornerRadius = 10

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        stackView.axis = .horizontal
        
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            //stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        stackView.addArrangedSubview(btn1)
        stackView.addArrangedSubview(btn2)
        stackView.addArrangedSubview(btn3)
        stackView.addArrangedSubview(btn4)
        self.view.addSubview(label)
         
    }
    
    @objc func btn1Action(sender: UIButton!) {
        label.text = "btn1"
    }
    
    @objc func btn2Action(sender: UIButton!) {
        label.text = "btn2"
    }
    
    @objc func btn3Action(sender: UIButton!) {
        label.text = "btn3"
    }
    
    @objc func btn4Action(sender: UIButton!) {
        label.text = "btn4"
    }
    
}

func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
    let currentLocation = location?.mapPointGeo()
    if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude {
        print("MTMapView updateCurrentLocation (\(latitude), \(longitude)) accuracy (\(accuracy)")
    }
}

func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
    print("MTMapView updateDeviceHeading (\(headingAngle) degrees")
}
            

