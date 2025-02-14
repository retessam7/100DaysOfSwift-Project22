//
//  ViewController.swift
//  Project22
//
//  Created by Aleksei Ivanov on 13/2/25.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    // lets us configure how we want to be notified about location, and will also deliver location updates to us
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        // set ourselves as its delegate (need to conform to the protocol)
        locationManager?.delegate = self
        // Requesting location authorization is a non-blocking call, which means your code will carry on executing
        locationManager?.requestWhenInUseAuthorization()
        
        // as changing the label's text, we'll be using color to tell users how distant the beacon is
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager?.requestAlwaysAuthorization()
            
        case .authorizedAlways:
            // is our device able to monitor iBeacons?
                if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                    // Ranging is the ability to tell roughly how far something else is away from our device
                    if CLLocationManager.isRangingAvailable() {
                        // do stuff
                    }
                }
        default:
            break
            }
        }
}

