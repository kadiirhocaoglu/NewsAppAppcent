//
//  NewsTableViewCellViewModel.swift
//  AppcentNewsApp
//
//  Created by Kadir Hocaoğlu on 13.05.2024.
//

import Foundation
import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let publishedAt: String?
    let imageURL: URL?
    var imageData: Data? = nil
    init(title: String, subtitle: String, publishedAt: String, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.publishedAt = publishedAt
    }
    
}

