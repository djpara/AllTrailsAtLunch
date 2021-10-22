//
//  MKMapView+Radius.swift
//  AllTrails
//
//  Created by David Para on 10/21/21.
//

import MapKit

// https://stackoverflow.com/questions/29093843/how-to-get-radius-from-visible-area-of-mkmapview
extension MKMapView {
    func topCenterCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }

    func currentRadius() -> Double {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation)
    }
}
