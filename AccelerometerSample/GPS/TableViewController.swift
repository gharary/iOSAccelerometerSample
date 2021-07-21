//
//  TableViewController.swift
//  AccelerometerSample
//
//  Created by Mohammad Gharari on 7/2/21.
//

import UIKit
import MapKit
import CoreLocation


class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var GPSTableView: UITableView!
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var totalDistance:UILabel!
    
    let cellIdentifier = "GPSCell"
    
    var timer = Timer()
    
    /// array of distance to show in `TableView`
    var distance:[Double] = []
    
    /// list of all locations
    var AllLocations:[CLLocation] = []
    
    /// Holding locations to calculate distance
    var distanceLocation:[CLLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// This method authorize and config Location service.
        locationManagerConfig()
        configMapview()
        distance = [0]
        
        
        /// This timer is to fetch data from Location
        timer = Timer.scheduledTimer(timeInterval: 3 * 60, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        

        RunLoop.current.add(timer, forMode: .common)
        timer.tolerance = 0.5
        
        

        
    }

    func configMapview() {
        
        mapView.mapType = MKMapType.standard
        mapView.delegate = self
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        
        guard let location = AllLocations.first?.coordinate, AllLocations.count > 0 else { return }
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003,longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    @objc func fireTimer() {
        calculateDistance()
        
        GPSTableView.reloadData()
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return distance.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = "Distance Traveled (last 3 min):  \(String(format: "%.1f", distance[indexPath.row])) Meters"
        totalDistance.text = "Total Distance Traveled:\(String(format: "%.1f", distance.sum())) Meters"
        cell.backgroundColor = .clear
        
        /// just to make `UI` more fancy, I  mark the cell of max distance with `green` and min distance with `red`
        guard distance.count > 3 else { return cell }
        if distance.min() == distance[indexPath.row] {
            cell.backgroundColor = .red
        } else if distance.max() == distance[indexPath.row] {
            cell.backgroundColor = .green
        }
        
        return cell
    }
    

    
}

extension TableViewController: CLLocationManagerDelegate {
    /// `LocationManager` configurations
    func locationManagerConfig() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        /// To make the accuracy more accurate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = CLActivityType.automotiveNavigation
        
        
        /// for efficiency, I ignore moves less than 3 meter to be triggered
        locationManager.distanceFilter = 3
        
        
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        print(clLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .notDetermined || status == .restricted {
            self.locationManager.stopUpdatingLocation()
        } else {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.first != nil else {
            return
        }
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)

        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            
            /// check if the `newLocation` is not more than `20`radius meter of user's actual location
            /// and also check to ensure data is recent
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            /// Prints the locations that are observed
            print("locations = \(newLocation.coordinate.latitude) \(newLocation.coordinate.longitude)")
            AllLocations.append(newLocation)
            
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center:myLocation,span:MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            
            
            //map.addAnnotation(mkAnnotation)
            
            if AllLocations.count > 1 {
                let startPointAnnot = MKPointAnnotation()
                startPointAnnot.coordinate = AllLocations.first!.coordinate
                startPointAnnot.subtitle = "Start Point"
                mapView.addAnnotation(startPointAnnot)
                
                
                let herePointAnnot = MKPointAnnotation()
                herePointAnnot.coordinate = newLocation.coordinate
                herePointAnnot.subtitle = "Here"
                mapView.addAnnotation(herePointAnnot)
                let sourceInd = AllLocations.count - 1
                let destinationInd = AllLocations.count - 2
                
                let c1 = AllLocations[sourceInd].coordinate
                let c2 = AllLocations[destinationInd].coordinate
                let polyline = MKPolyline(coordinates: [c1,c2], count: 2)
                mapView.addOverlay(polyline,level:.aboveRoads)
            }
            
            distanceLocation.append(newLocation)
            
        }
        
    }
    
    
    /// This method calculate distance traveled between two points `LastLocation` and `NewLocation`
    func calculateDistance() {
        if let lastLocation = distanceLocation.first {
            guard let delta = distanceLocation.last?.distance(from: lastLocation) else { return  }
             
            distance.append(Measurement(value: delta, unit: UnitLength.meters).value)
            distanceLocation = []
        }
        
    }


}
extension TableViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5
        return renderer
    }
}
