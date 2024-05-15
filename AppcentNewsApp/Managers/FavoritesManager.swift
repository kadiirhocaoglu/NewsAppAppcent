//
//  FavoritesManager.swift
//  AppcentNewsApp
//
//  Created by Kadir Hocaoğlu on 14.05.2024.
//

import Foundation


final class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "FavoriteArticles"
    
    func addFavorite(_ article: Article) {
        var favorites = getFavorites()
        favorites.append(article)
        saveFavorites(favorites)
    }
    
    func removeFavorite(_ article: Article) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(where: { $0.url == article.url }) {
            favorites.remove(at: index)
            saveFavorites(favorites)
        }
    }
    
    func isArticleFavorited(_ article: Article) -> Bool {
            let favorites = getFavorites()
            return favorites.contains { $0.url == article.url }
        }
    
    func getFavorites() -> [Article] {
        if let data = userDefaults.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([Article].self, from: data) {
            return favorites.reversed()
        }
        return []
    }
    
    private func saveFavorites(_ favorites: [Article]) {
        if let data = try? JSONEncoder().encode(favorites) {
            userDefaults.set(data, forKey: favoritesKey)
        }
    }
}
