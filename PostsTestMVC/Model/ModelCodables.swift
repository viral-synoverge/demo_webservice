//
//  ModelCodables.swift
//  PostsTestMVC
//
//  Created by Ivan Yavorin on 03.12.2020.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

// MARK: - User
struct User: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK:  Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK:  Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK:  Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}

// MARK: - Comment
struct Comment: Codable {
    let postID, id: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}
