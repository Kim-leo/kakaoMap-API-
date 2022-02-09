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
        btn.addTarget(self, action: #selector(parseJSON(_:)), for: .touchUpInside)
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
    public var currentGu: String!
    
    var resultList = [Place]()

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
        
        fetchCurrentPlace() // 현재위치 "ㅇㅇ구"는 currentLocationAddressArray에 배열로, joinedAddressArray에는 String으로 저장됨.
    }
    /*
    func anotherTry() {
        let headers: HTTPHeaders = [
                    "Authorization": "KakaoAK [c1291537d6477a23673e8a1b0f4702ff]"
                ]
                
        let parameters: [String: Any] = [
                    "query": "keyword",
                    "page": "page",
                    "size": 15
                ]
    
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        AF.request(url,
                    method: .get,
                    parameters: parameters,
                    encoding: URLEncoding.default,
                    headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON { (json) in
                       
                        print(json)
                }
            
    }
    
    func letsTry() {
        let headers: HTTPHeaders = [
                    "Authorization": "KakaoAK [c1291537d6477a23673e8a1b0f4702ff]"
                ]
                
        let parameters: [String: Any] = [
                    "query": "keyword",
                    "page": "page",
                    "size": 15
                ]
        //let urlString = "kakaomap://search?q=로또&p=37.537229,127.005515"
        let urlString = "https://dapi.kakao.com/v2/local/search/keyword.{format}"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
                
        AF.request(url, method: .get,
             parameters: parameters, headers: headers)
             .responseJSON(completionHandler: { response in
                 switch response.result {
                 case .success(let value):
                    if let detailsPlace = JSON(value)["documents"].array{
                        for item in detailsPlace {
                            let placeName = item["place_name"].string ?? ""
                            let roadAdressName = item["road_address_name"].string ?? ""
                            let longitudeX = item["x"].string ?? ""
                            let latitudeY = item["y"].string ?? ""
                            self.resultList.append(Place(placeName: placeName,
                            roadAdressName: roadAdressName, longitudeX: longitudeX, latitudeY: latitudeY))
                            
                        }
                        
                     }
                     
                    
                //print("\(self.resultList[0].placeName)")
                //print("\(self.resultList[1].placeName)")
                //print("\(self.resultList[2].placeName)")

                   case .failure(let error):
                       print(error)
                   }
               })
        print(self.resultList)
    }
    */
    @objc func fetchAddress(_ sender: UIButton) {
        let locationNow = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        
        geoCoder.reverseGeocodeLocation(locationNow, preferredLocale: locale) { [self] (poilItem1, error) in
            if let address:[CLPlacemark] = poilItem1 {
                if let locality: String = address.last?.locality {
                    currentLocationAddressArray.append(locality)
                }
            }
            currentLocationAddressArray.append("로또")
            currentGu = currentLocationAddressArray.joined(separator: " ")
            print(currentGu!)
            searchBar.text = self.currentGu
            print(searchBar.text!)
        }
        currentLocationAddressArray = []
        currentGu = ""
    }
    
    @objc func parseJSON(_ sender: UIButton) {
        let url = Bundle.main.url(forResource: "storeAddress", withExtension: "json")
        
        do {
            let stringData = try String(contentsOf: url!, encoding: String.Encoding.utf8)
            let data = stringData.data(using: String.Encoding.utf8)
            let stores = try JSONDecoder().decode(storeAddress.self, from: data!)
//            for obj in stores.Gangnam {
//                print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
//            }
//
//            print(stores.Dongdaemun)
            
            /*
                1. 현재위치 받아오기("ㅇㅇ구")
                2. 현재위치와 stores.ㅇㅇ 비교하기
                3. 비교해서 맞으면 해당 구의 가게 리스트 가져오기
             4. 가져온 리스트의 주소를 좌표로 변환하기
             5. 변환된 좌표로 핀 꼽기
             */
            
            switch currentGu {
            case "강북구":
                for obj in stores.Gangbuk {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "강남구":
                for obj in stores.Gangnam {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "강동구":
                for obj in stores.Gangdong {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "강서구":
                for obj in stores.Gangseo {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "관악구":
                for obj in stores.Gwanak {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "광진구":
                for obj in stores.Gwangjin {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "구로구":
                for obj in stores.Guro {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "금천구":
                for obj in stores.GeumCheon {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "도봉구":
                for obj in stores.Dobong {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "동대문구":
                for obj in stores.Dongdaemun {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "동작구":
                for obj in stores.Dongjak {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "마포구":
                for obj in stores.Mapo {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "서대문구":
                for obj in stores.Seodaemun {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "서초구":
                for obj in stores.Seocho {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "성동구":
                for obj in stores.Seongdong {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "성북구":
                for obj in stores.Seongbuk {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "송파구":
                for obj in stores.Songpa {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "양천구":
                for obj in stores.Yangcheon {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "영등포구":
                for obj in stores.Yeongdeungpo {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "용산구":
                for obj in stores.Yongsan {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "은평구":
                for obj in stores.Eunpyeong {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "종로구":
                for obj in stores.Jongno {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "중구":
                for obj in stores.Jung {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            case "중랑구":
                for obj in stores.Jungnang {
                    print("name: \(obj.name), 도로명주소: \(obj.addressStreet), 지번주소: \(obj.addressLand)")
                }
            default:
                print("oops")
            }
            currentLocationAddressArray = []
            currentGu = ""
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    //현재위치 "ㅇㅇ구" 받아오기
    func fetchCurrentPlace() {
        let locationNow = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        
        geoCoder.reverseGeocodeLocation(locationNow, preferredLocale: locale) { [self] (poilItem1, error) in
            if let address:[CLPlacemark] = poilItem1 {
                if let locality: String = address.last?.locality {
                    currentLocationAddressArray.append(locality)
                }
            }
            //currentLocationAddressArray.append("로또")
            currentGu = currentLocationAddressArray.joined(separator: " ")
            print(currentGu!)
            //searchBar.text = self.currentGu
            //print(searchBar.text!)
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
        /*
        //csv파일 내의 가게 "구"와 현재위치 "구" 비교하기
        if nameAndAddress[1][0] as? String == "강남구" {
            print(nameAndAddress[1])
        } else {
            print("opps")
        }*/
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
            

