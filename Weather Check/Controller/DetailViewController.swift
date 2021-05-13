//
//  DetailViewController.swift
//  Weather Check
//
//  Created by Onur Mavitas on 13.05.2021.
//

import UIKit
import Network

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var detailTableView: UITableView!
    var rowSelected : Int?
    var cityName: String?

    var weatherDetail = Array<WeatherDetail>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifyConnection()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        //register the nib file to the tableview
        let nib = UINib(nibName: "DetailTableViewCell", bundle: nil)
        detailTableView.register(nib, forCellReuseIdentifier: "DetailTableViewCell")
        
        if let name = cityName {
            cityNameLabel.text = name
        }
    }
    
    func verifyConnection() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in

            if path.status != .satisfied {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Oops!", message: "There is a problem with your internet connection", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDetail.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        
        let imageName = "\(weatherDetail[indexPath.row].weather_state_abbr)"
        cell.weatherImageView.image = UIImage(named: imageName)
        cell.weatherStateLabel.text = weatherDetail[indexPath.row].weather_state_name
        cell.dateLabel.text = weatherDetail[indexPath.row].applicable_date
        cell.temperatureLabel.text = String(format: "Temperature: %.2f", weatherDetail[indexPath.row].the_temp)
        cell.humidityLabel.text = String(format: "Humidity: \(weatherDetail[indexPath.row].humidity)")
        cell.visiblityLabel.text = String(format: "Visiblity: %.1f", weatherDetail[indexPath.row].visibility)
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
