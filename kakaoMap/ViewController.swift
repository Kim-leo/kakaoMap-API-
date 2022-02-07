//
//  ViewController.swift
//  kakaoMap
//
//  Created by 김승현 on 2021/12/31.
//

import UIKit
import SnapKit
import CoreLocation

public let defaultPosition = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)


class ViewController: UIViewController, MTMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
   
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
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(named: "currentLocation.png"), for: .normal)
        btn.tintColor = .systemBlue
        btn.setBackgroundImage(UIImage(named: "location"), for: .normal)
        btn.addTarget(self, action: #selector(backToCurrentPlace), for: .touchUpInside)
        return btn
    }()
    
    let checkWinBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .red
        btn.setTitle("당첨 확인", for: .normal)
        btn.addTarget(self, action: #selector(checkPopUpBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    let nearStoreLocBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .orange
        btn.setTitle("주변 가게", for: .normal)
        btn.addTarget(self, action: #selector(changeIntoKorean(_:)), for: .touchUpInside)
        return btn
    }()
    
    let recommendNumberBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .yellow
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("번호 추천", for: .normal)
        btn.addTarget(self, action: #selector(didTapPopUpBtn(_:)), for: .touchUpInside)
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
    
    public var currentLocationAddressArray = [String]()
    public var joinedAddressArray: String!
    

    var mapView: MTMapView!
    
    var mapPoint1: MTMapPoint!
    var poilItem1: MTMapPOIItem?
    
    //검색기능
    let searchController = UISearchController(searchResultsController: nil)
    var searchWords: String?
    

    var locationManager: CLLocationManager!
    var currentLatitude: Double!
    var currentLongitude: Double!
    
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
        
        locationManager = CLLocationManager()
        currentLatitude = defaultPosition.latitude
        currentLongitude = defaultPosition.longitude
  
    }
    
    @objc func changeIntoKorean(_ sender: UIButton) {
        let locationNow = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        
        geoCoder.reverseGeocodeLocation(locationNow, preferredLocale: locale) { [self] (poilItem1, error) in
            if let address:[CLPlacemark] = poilItem1 {
                if let thoroughfare: String = address.last?.thoroughfare { currentLocationAddressArray.append(thoroughfare)}
            }
            currentLocationAddressArray.append("로또")
            joinedAddressArray = currentLocationAddressArray.joined(separator: " ")
            print(joinedAddressArray!)
            searchBar.text = self.joinedAddressArray
            print(searchBar.text!)
        }
        
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            print(text)      
        }
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
    
    @objc func randomNumber() {
        var numbers: [Int] = []
        while numbers.count < 6 {
            let number = Int.random(in: 1...45)
            if !numbers.contains(number) {
                numbers.append(number)
            }
        }
        for i in numbers.sorted() {
            print(i, terminator: " ")
        }
    }
    
    @objc func backToCurrentPlace() {
        mapView.setMapCenter(MTMapPoint(geoCoord: defaultPosition), animated: true)
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithHeading
    }
    
    @objc func didTapPopUpBtn(_ sender: UIButton) {
        let popUpViewController = PopUpViewController()
        popUpViewController.modalPresentationStyle = .overCurrentContext
        present(popUpViewController, animated: true, completion: nil)
    }
    
    @objc func checkPopUpBtn(_ sender: UIButton) {
        let checkPopUpViewController = checkViewController()
        checkPopUpViewController.modalPresentationStyle = .overCurrentContext
        present(checkPopUpViewController, animated: true, completion: nil)
    }
    
 
    
    //AutoLayout
    func searchBarAutoLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
        }
    }

    func currentLocBtnAutoLayout() {
        currentLocBtn.snp.makeConstraints { make in
            make.size.width.height.equalTo(50)
            make.trailing.equalTo(view).offset(-10)
            make.bottom.equalTo(bottomStackView.snp.top).offset(-20)
        }
    }
    func bottomStackViewAutoLayout() {
        bottomStackView.snp.makeConstraints { make in
            make.size.height.equalTo(70)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
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
            

