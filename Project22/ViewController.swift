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
                        startScanning()
                    }
                }
        default:
            break
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
            
            // CLProximity as an enum that might change in the future
            @unknown default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                
            }
        }
    }
}

// UUID: You're in a Acme Hardware Supplies store.
// Major: You're in the Glasgow branch.
// Minor: You're in the shoe department on the third floor.
