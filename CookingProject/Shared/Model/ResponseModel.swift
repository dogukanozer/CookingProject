//
//  ResponseModel.swift
//  CookingProject
//
//  Created by Macbook Air on 16.05.2023.
//

import Foundation

// MARK: - Search Response Model
struct SearchResponseModel: Codable {
    let results: [ResultModel]
}

// MARK: - Result
struct ResultModel: Codable {
    let id: Int
    let title: String
    let image: String
}

// MARK: - Detail Response Model
struct DetailResponseModel: Codable {
    let id: Int
    let title: String
    let summary: String
}
