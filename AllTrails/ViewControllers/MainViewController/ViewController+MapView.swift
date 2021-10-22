//
//  ViewController+MapView.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import MapKit

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let restaurant = viewModel.restaurants.value.all
            .first { restaurant in
                let restaurantCoordinate = restaurant.geometry.location.toCLLocation().coordinate
                return restaurantCoordinate.latitude == view.annotation?.coordinate.latitude &&
                restaurantCoordinate.longitude == view.annotation?.coordinate.longitude
            }
        print(restaurant)
    }
}
