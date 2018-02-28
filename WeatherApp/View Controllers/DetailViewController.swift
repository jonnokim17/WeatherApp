//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Jonathan Kim on 2/27/18.
//  Copyright © 2018 Jonathan Kim. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var forecastData = [Weather]()
    var coordinate: CLLocationCoordinate2D?
    var cityName = ""
    var countryName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(handleDismiss))

        let geoCoder = CLGeocoder()
        guard let coordinate = coordinate else { return }
        let coordinateLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(coordinateLocation, completionHandler: { placemarks, error in
            guard let firstPlacemark = placemarks?.first else { return }
            guard
                let cityName = firstPlacemark.locality,
                let countryName = firstPlacemark.country
            else { return }

            self.cityName = cityName
            self.countryName = countryName

            self.title = "\(cityName), \(countryName)"
        })
    }

    @objc func handleDismiss() {
        dismiss(animated: true) {
            guard let coordinate = self.coordinate else { return }
            guard let currentForecast = self.forecastData.first else { return }

            // saving light-weight data using UserDefaults
            UserDefaults.standard.removeObject(forKey: "offlineData")
            UserDefaults.standard.set(["latitude": coordinate.latitude, "longitude": coordinate.longitude, "currentTemperature": currentForecast.temperature, "currentSummary": currentForecast.summary, "weatherIcon": currentForecast.icon, "city": self.cityName, "country": self.countryName], forKey: "offlineData")
            UserDefaults.standard.synchronize()
        }
    }
}
