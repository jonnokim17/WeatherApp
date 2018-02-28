//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Jonathan Kim on 2/27/18.
//  Copyright © 2018 Jonathan Kim. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
            UserDefaults.standard.removeObject(forKey: "offlineData")
            UserDefaults.standard.set(["latitude": coordinate.latitude, "longitude": coordinate.longitude, "currentTemperature": currentForecast.temperature, "currentSummary": currentForecast.summary, "weatherIcon": currentForecast.icon, "city": self.cityName, "country": self.countryName], forKey: "offlineData")
            UserDefaults.standard.synchronize()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        let weatherObject = forecastData[indexPath.row]

        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) °F"
        cell.imageView?.image = UIImage(named: weatherObject.icon)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }
}
