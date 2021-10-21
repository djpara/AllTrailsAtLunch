//
//  FavoritesService.swift
//  AllTrails
//
//  Created by David Para on 10/21/21.
//

import Foundation

class FavoritesService {
    private var favorites = [String]()
    private var userDefaults: UserDefaults
    
    init(with userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadFromDefaults()
    }
    
    private func loadFromDefaults() {
        favorites = (userDefaults.array(forKey: "favorites") as? [String]) ?? []
    }
    
    func saveToFavorites(restaurant: Restaurant) {
        favorites.append(restaurant.id)
        userDefaults.set(favorites, forKey: "favorites")
    }
    
    func confirmFavorite(restaurant: Restaurant) -> Bool {
        favorites.contains { id in id == restaurant.id }
    }
    
    func removeFromFavorites(restaurant: Restaurant) {
        favorites.removeAll { id in id == restaurant.id }
        userDefaults.set(favorites, forKey: "favorites")
    }
}
