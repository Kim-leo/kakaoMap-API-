//
//  Models.swift
//  jsonPractice
//
//  Created by 김승현 on 2022/02/09.
//

import Foundation

struct storeAddress: Decodable {
    let Dobong: [store]
    let Dongdaemun: [store]
    let Dongjak: [store]
    let Eunpyeong: [store]
    let Gangbuk: [store]
    let Gangdong: [store]
    let Gangnam: [store]
    let Gangseo: [store]
    let GeumCheon: [store]
    let Guro: [store]
    let Gwanak: [store]
    let Gwangjin: [store]
    let Jongno: [store]
    let Jung: [store]
    let Jungnang: [store]
    let Mapo: [store]
    let Nowon: [store]
    let Seocho: [store]
    let Seodaemun: [store]
    let Seongbuk: [store]
    let Seongdong: [store]
    let Songpa: [store]
    let Yangcheon: [store]
    let Yeongdeungpo: [store]
    let Yongsan: [store]
    
    
}

struct store: Decodable {
    let name: String
    let addressStreet: String
    let addressLand: String
    
    init(name:String, addressStreet: String, addressLand: String) {
        self.name = name
        self.addressStreet = addressStreet
        self.addressLand = addressLand
    }
}


