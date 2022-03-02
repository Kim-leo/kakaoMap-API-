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


public let defaultPosition = MTMapPointGeo(latitude: 37.5744220273106, longitude: 127.057311940389)


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
        btn.addTarget(self, action: #selector(nearStore(_:)), for: .touchUpInside)
        return btn
    }()
    
    let goToKakaoMapAppBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .yellow
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("길찾기", for: .normal)
        btn.addTarget(self, action: #selector(goToKakakoMapApp(_:)), for: .touchUpInside)
        return btn
    }()
    
    let recommendNumberBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .green
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
        poilItem1?.markerType = .yellowPin
        poilItem1?.mapPoint = mapPoint1
        poilItem1?.itemName = "현재 위치"
        mapView.add(poilItem1)
        
        //searchBar
         setSearchBar()
        
       //stackview and 3 buttons
        self.view.addSubview(bottomStackView)
        bottomStackViewAutoLayout()
        
        self.view.addSubview(currentLocBtn)
        currentLocBtnAutoLayout()
        
        bottomStackView.addArrangedSubview(checkWinBtn)
        bottomStackView.addArrangedSubview(nearStoreLocBtn)
        bottomStackView.addArrangedSubview(goToKakaoMapAppBtn)
        bottomStackView.addArrangedSubview(recommendNumberBtn)
        
        locationManager = CLLocationManager()
        currentLatitude = defaultPosition.latitude
        currentLongitude = defaultPosition.longitude
        
        // 현재위치 "ㅇㅇ구"는 currentLocationAddressArray에 배열로, currentLocality에는 String으로 저장됨.
        fetchCurrentPlace()
      
    }
    //길찾기 버튼 -> 카카오맵App 실
    @objc func goToKakakoMapApp(_ sender: UIButton) {
        let alert = UIAlertController(title: "카카오맵 열기", message: "길찾기를 위해 카카오맵을 실행하시나요?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "실행", style: .default) { (action) in
            //sp: 출발점 -> 현재위치
            //ep: 도착점 -> 해당 핀 가게 위치
            let kakaoMap = "kakaomap://route?sp=\(defaultPosition.latitude),\(defaultPosition.longitude)&ep=37.4979502,127.0276368&by=FOOT"
            
            let kakaoMapURL = NSURL(string: kakaoMap)
            
            if (UIApplication.shared.canOpenURL(kakaoMapURL! as URL)) {
                UIApplication.shared.open(kakaoMapURL! as URL)
            } else {
                print("카카오맵 없음!")
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
        
        
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
                //ㅇㅇ구
//                if let administrativeArea: String = address.last?.administrativeArea {
//                    currentLocationAddressArray.append(administrativeArea)
//                }
                //ㅇㅇ시
                if let locality: String = address.last?.locality{
                    currentLocationAddressArray.append(locality)
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
    
    func getStoresCoordinates() {
        let headers: HTTPHeaders = [
                    "Authorization": "" //my api KEY
                ]
                
        let parameters: [String: Any] = [
                    "query": currentLocality + "복권",
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
                         
                         //print(eachStoreName!, eachStoreCoordinateX!, eachStoreCoordinateY!)
                         
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
    
    //서치바
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .systemGray6
        searchBar.placeholder = "장소를 검색해보세요."
        self.view.addSubview(searchBar)
        searchBarAutoLayout()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var text = searchBar.text {
            print(text)
            
            let headers: HTTPHeaders = [
                        "Authorization": "" //KakaoAK KEY
                    ]
                    
            let parameters: [String: Any] = [
                        "query": text + "복권",
                        "page": 30, //결과페이지 번호 (1~45)
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
                         
                         mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(resultList[0].y)!, longitude: Double(resultList[0].x)!)), animated: true)
                         mapView.showCurrentLocationMarker = true
                         mapView.currentLocationTrackingMode = .onWithHeading
                         
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
                         //다음 검색을 위해 이전 결과 리스트 초기화.
                         resultList = [Place]()
                         
                       case .failure(let error):
                           print(error)
                       }
                   })
        }
        
    }
    
    //주변 가게 좌표 받아오기
    @objc func nearStore(_ sender: UIButton) {
        getStoresCoordinates()
        self.viewDidLoad()
    }
    
   //현재위치 버튼
    @objc func backToCurrentPlace() {
        mapView.setMapCenter(MTMapPoint(geoCoord: defaultPosition), animated: true)
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithHeading
    }
    
   //번호추천 버튼
    @objc func didTapPopUpBtn(_ sender: UIButton) {
        let popUpViewController = PopUpViewController()
        popUpViewController.modalPresentationStyle = .overCurrentContext
        present(popUpViewController, animated: true, completion: nil)
    }
    
   //당첨확인 버튼
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
            

