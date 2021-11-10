//
//  Models.swift
//  UnsplashTest v1
//
//  Created by Максим on 04/11/2021.
//

import Foundation

struct SeachResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [URLKing.RawValue: String]
    let user: UserPhoto
    let created_at: String
    let id: String
    
    enum URLKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct UserPhoto: Decodable {
    let username: String
    let name: String
}

struct Statictic: Decodable {
    let id: String
    let downloads: Int
    let createdAt: String
    let location: Location?
    let user: UserPhoto
    let color: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case downloads
        case createdAt = "created_at"
        case location
        case user
        case color
    }
}

struct Location: Decodable {
    let name: String?
}
