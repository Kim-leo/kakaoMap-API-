//
//  Film.swift
//  kakaoMap
//
//  Created by 김승현 on 2022/02/08.
//

import Foundation

struct Film: Decodable {
    let id: Int
    let title: String
    let openingCrawl: String
    let director: String
    let director: String
    let priducerL: String
    let releaseDate: String
    let starships: [String]
    
    enum CodingKeys: String, CodingKeys {
        case id = "episode_id"
        case title
        case openingCrawl = "opening_crawl"
        case diretor
        case producer
        case releaseDate = "release_date"
        case starships
    }
}
