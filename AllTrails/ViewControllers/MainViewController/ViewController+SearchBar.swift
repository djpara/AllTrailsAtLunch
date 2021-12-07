//
//  ViewController+SearchBar.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import Foundation
import UIKit

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let currentLocation = locationManager.location else { return }
        viewModel.loadNearbyRestaurants(for: currentLocation, radius: currentRadius, searchKeyword: searchBar.text)
        refresh()
        searchBar.resignFirstResponder()
    }
}
