//
//  ImageDataModel.swift
//  ImgurSearchs
//
//  Created by Govind Kumar on 15/06/23.
//

import Foundation

// MARK: - ImageData Model
struct ImageDataModel: Codable {
    let data: [ImageData]?
    let success: Bool?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case success = "success"
        case status = "status"
    }
}

// MARK: - Image Data
struct ImageData: Codable {
    let id: String?
    let title: String?
    let dateTime: Double?
    let imagesCount: Int?
    let images: [Image]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case dateTime = "datetime"
        case imagesCount = "images_count"
        case images = "images"
    }
}

// MARK: - Image
struct Image: Codable {
    let id: String?
    let link: String?
    let type: String?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case link = "link"
        case type = "type"
    }
}
