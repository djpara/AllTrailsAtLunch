//
//  ViewController+RestaurantTableViewCellDelegate.swift
//  AllTrails
//
//  Created by David Para on 10/21/21.
//

import Foundation

extension ViewController: RestaurantTableViewCellDelegate {
    func cell(_ restaurantTableViewCell: RestaurantTableViewCell, didMakeFavorite restaurant: Restaurant) {
        viewModel.favoritesService.saveToFavorites(restaurant: restaurant)
    }
    
    func cell(_ restaurantTableViewCell: RestaurantTableViewCell, didRemoveFromFavorites restaurant: Restaurant) {
        viewModel.favoritesService.removeFromFavorites(restaurant: restaurant)
    }
}
