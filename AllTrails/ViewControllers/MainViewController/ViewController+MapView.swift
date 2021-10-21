//
//  ViewController+MapView.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import MapKit

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected pin \(view)")
    }
}
