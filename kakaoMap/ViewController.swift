//
//  ViewController.swift
//  kakaoMap
//
//  Created by 김승현 on 2021/12/31.
//

import UIKit

public let defaultPosition = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)

class ViewController: UIViewController, MTMapViewDelegate, UISearchBarDelegate {
    
    var nameAndAddress = [[String]]()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.searchTextField.backgroundColor = .white
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return searchBar
    }()
    
    let currentLocBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(named: "location"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "location"), for: .normal)
        btn.addTarget(self, action: #selector(loadAddressFromCSV(_:)), for: .touchUpInside)
        return btn
    }()
    
    let checkWinBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .red
        return btn
    }()
    
    let nearStoreLocBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .orange
        return btn
    }()
    
    let recommendNumberBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .yellow
        return btn
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()
    
    

    var mapView: MTMapView!
    
    var mapPoint1: MTMapPoint!
    var poilItem1: MTMapPOIItem?
    
    //검색기능
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MTMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
        
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
        
       //searchBar
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        searchBarAutoLayout()
        
       //stackview and 3 buttons
        self.view.addSubview(bottomStackView)
        bottomStackViewAutoLayout()
        
        self.view.addSubview(currentLocBtn)
        currentLocBtnAutoLayout()
        
        bottomStackView.addArrangedSubview(checkWinBtn)
        bottomStackView.addArrangedSubview(nearStoreLocBtn)
        bottomStackView.addArrangedSubview(recommendNumberBtn)
         
    }
    
    func searchBarAutoLayout() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            print(text)
        }
    }
    
    
    func currentLocBtnAutoLayout() {
        currentLocBtn.translatesAutoresizingMaskIntoConstraints = false
        currentLocBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentLocBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        currentLocBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        currentLocBtn.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -20).isActive = true
    }
    
    func bottomStackViewAutoLayout() {
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
    
    func parseLocationCSV(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                for item in dataArr {
                    if nameAndAddress.count < 50 {
                        nameAndAddress.append(item)
                    }
                }
            }
        } catch {
            print("Error")
        }
    }
    
    @objc func loadAddressFromCSV(_ sender: UIButton) {
        let path = Bundle.main.path(forResource: "nameAndAddress", ofType: ".csv")!
        parseLocationCSV(url: URL(fileURLWithPath: path))
        print(nameAndAddress)
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
            

