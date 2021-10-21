//
//  ViewController+RestaurantTableViewCellDelegate.swift
//  AllTrails
//
//  Created by David Para on 10/21/21.
//

import Foundation

extension ViewController: RestaurantTableViewCellDelegate {
    func cell(_ restaurantTableViewCell: RestaurantTableViewCell, didMakeFavorite restaurant: Restaurant) {
        restaurant.isFavorite.toggle()
        r
    }
}
