//
//  ViewController+TableView.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.restaurants.value.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.ID, for: indexPath) as? RestaurantTableViewCell else {
            return UITableViewCell()
        }
        let restaurant = viewModel.restaurants.value.all[indexPath.row]
        cell.restaurant = restaurant
        cell.isFavorite = viewModel.favoritesService.confirmFavorite(restaurant: restaurant)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}
