//
//  ViewController.swift
//  kakaoMap
//
//  Created by 김승현 on 2021/12/31.
//

import UIKit
import SnapKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SwiftSoup


public let defaultPosition = MTMapPointGeo(latitude: 37.562615812096, longitude: 127.063214443253)


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
        btn.addTarget(self, action: #selector(getStoresCoordinates(_:)), for: .touchUpInside)
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
    var currentLocality: String!
    var eachStoreName: String!
    var eachStoreCoordinateX: Double!
    var eachStoreCoordinateY: Double!

    var mapView: MTMapView!
    
    var mapPoint1: MTMapPoint!
    var poilItem1: MTMapPOIItem?
    
    var resultList = [Place]()
    var resultListCount = 0
    
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
        poilItem1?.markerType = MTMapPOIItemMarkerType.bluePin
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
        
        
        // 현재위치 "ㅇㅇ구"는 currentLocationAddressArray에 배열로, joinedAddressArray에는 String으로 저장됨.
        fetchCurrentPlace()
      
        
    }
    
    //각 가게 별 좌표와 이름으로 핀 만들기.
    @discardableResult
    func createPin(itemName: String, getX: Double, getY: Double, markerType: MTMapPOIItemMarkerType) -> MTMapPOIItem {
        let poilItem = MTMapPOIItem()
        poilItem.itemName = "\(itemName)"
        poilItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: getX, longitude: getY))
        poilItem.markerType = .redPin
        mapView.addPOIItems([poilItem])
        return poilItem
    }
    
    
    //현재위치 "ㅇㅇ구" 받아오기
    func fetchCurrentPlace() {
        let locationNow = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        
        geoCoder.reverseGeocodeLocation(locationNow, preferredLocale: locale) { [self] (poilItem1, error) in
            if let address:[CLPlacemark] = poilItem1 {
                //ㅇㅇ시
                if let city: String = address.last?.locality{
                    currentLocationAddressArray.append(city)
                }
                //ㅇㅇ동
//                if let dong: String = address.last?.thoroughfare {
//                    currentLocationAddressArray.append(dong)
//                }
            }
            currentLocality = currentLocationAddressArray.joined(separator: " ")
            print(currentLocality!)
        }
    }
    
    //주변 가게 좌표 받아오기
    @objc func getStoresCoordinates(_ sender: UIButton) {
        
        let headers: HTTPHeaders = [
                    "Authorization": "KakaoAK c1291537d6477a23673e8a1b0f4702ff"
                ]
                
        let parameters: [String: Any] = [
                    "query": currentLocality + "로또",
                    "page": 20, //결과페이지 번호 (1~45)
                    "size": 15  //한 페이지에 보여질 문서의 개수 (1~15)
                    //"radius": 100
                ]
    
        let urlString = "https://dapi.kakao.com/v2/local/search/keyword.json?radius=200"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
                
        AF.request(url, method: .get,
             parameters: parameters, headers: headers)
            .responseJSON(completionHandler: { [self] response in
                 switch response.result {
                 case .success(let value):
                    if let detailsPlace = JSON(value)["documents"].array{
                        for item in detailsPlace {
                            let placeName = item["place_name"].string ?? ""
                            let roadAdressName = item["road_address_name"].string ?? ""
                            let x = item["x"].string ?? ""
                            let y = item["y"].string ?? ""
                            self.resultList.append(Place(placeName: placeName,
                            roadAdressName: roadAdressName, x: x, y: y))
                        }
                     }
                     //여기서부터: 좌표를 가져온 후 지도상에 핀으로 출력해야 함.
                     //print(resultList[2].x)   127.asdasd
                     //print(resultList.count)  8
                     resultListCount = resultList.count
                     for i in 0..<resultListCount {
                         eachStoreCoordinateX = Double(resultList[i].x)
                         eachStoreCoordinateY = Double(resultList[i].y)
                         eachStoreName = resultList[i].placeName
                         
                         print(eachStoreName!, eachStoreCoordinateX!, eachStoreCoordinateY!)
                         createPin(itemName: eachStoreName, getX: eachStoreCoordinateY, getY: eachStoreCoordinateX, markerType: .redPin)
                         
                         eachStoreName = ""
                         eachStoreCoordinateX = 0
                         eachStoreCoordinateY = 0
                         
                     }
                     
                     
                     
                   case .failure(let error):
                       print(error)
                   }
               })
    }
    
    
        
    //현재위치 좌표 나타내기
    fileprivate func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingHeading()
        } else {
            print("위치 서비스 허용 off")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var text = searchBar.text {
            print(text)
        
                
        }
    }
  
    
    func parseLocationCSV(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                for item in dataArr {
                    /*
                    if nameAndAddress.count < 50 {
                        nameAndAddress.append(item)
                    }
                     */
                    nameAndAddress.append(item)
                }
            }
        } catch {
            print("Error")
        }
    }
    @objc func loadAddressFromCSV(_ sender: UIButton) {
        let path = Bundle.main.path(forResource: "storeAddress", ofType: ".csv")!
        parseLocationCSV(url: URL(fileURLWithPath: path))
        print(nameAndAddress, terminator: "")
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
            

