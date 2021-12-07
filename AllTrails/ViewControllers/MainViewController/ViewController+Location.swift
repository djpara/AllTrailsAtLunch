//
//  ViewController+Location.swift
//  AllTrails
//
//  Created by David Para on 10/20/21.
//

import CoreLocation
import UIKit

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            DispatchQueue.main.async {
                self.startTracking()
            }
        } else if manager.authorizationStatus == .denied {
            showOpenSettingsAlert()
        }
    }
    
    private func showOpenSettingsAlert() {
        let title = NSLocalizedString("Current Location Access", comment: "Access to user's current location")
        let message = NSLocalizedString("Open settings and allow AllTrails to access your current location to show nearby restaurants.", comment: "Requesting access to current location to search for and display nearby restaurants")
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
            let settingsTitle = NSLocalizedString("Settings", comment: "iOS Settings menu")
            let settingsAction = UIAlertAction(title: settingsTitle, style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            alertController.addAction(settingsAction)
        
            let cancelTitle = NSLocalizedString("Cancel", comment: "Cancel and dismiss alert without navigating to iOS Settings menu")
            let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: nil)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
    }
}
