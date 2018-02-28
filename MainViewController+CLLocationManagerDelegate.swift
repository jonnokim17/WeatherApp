//
//  MainViewController+CLLocationManagerDelegate.swift
//  WeatherApp
//
//  Created by Jonathan Kim on 2/27/18.
//  Copyright © 2018 Jonathan Kim. All rights reserved.
//

import UIKit

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard Reachability.isConnectedToNetwork() else { return }
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(10, 10)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let myLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true

        Weather.forecast(withLocation: myLocation) { (results: [Weather]?) in
            guard let weatherData = results else { return }

            guard let currentWeatherData = weatherData.first else { return }
            DispatchQueue.main.async {
                self.temperatureLabel.text = "\(Int(currentWeatherData.temperature)) °F"
                self.weatherDescriptionLabel.text = currentWeatherData.summary
                self.weatherIconImageView.image = UIImage(named: currentWeatherData.icon)
            }
        }

        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let firstPlacemark = placemarks?.first else {
                self.cityLabel.text = "Unknown"
                return
            }

            guard
                let cityName = firstPlacemark.locality,
                let countryName = firstPlacemark.country
                else { return }

            self.cityLabel.text = "\(cityName), \(countryName)"
        })
    }
}
