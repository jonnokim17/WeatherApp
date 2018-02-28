//
//  DetailViewController+UITableViewDelegate.swift
//  WeatherApp
//
//  Created by Jonathan Kim on 2/27/18.
//  Copyright © 2018 Jonathan Kim. All rights reserved.
//

import UIKit

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
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
