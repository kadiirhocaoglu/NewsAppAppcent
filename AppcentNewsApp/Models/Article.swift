//
//  Article.swift
//  AppcentNewsApp
//
//  Created by Kadir Hocaoğlu on 13.05.2024.
//

import Foundation

struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
