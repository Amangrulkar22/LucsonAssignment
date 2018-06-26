//
//  HomeViewController.swift
//  LucsonAssignment
//
//  Created by Ashwinkumar Mangrulkar on 26/06/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import CoreLocation

enum ButtonType: Int {
    case Source
    case Destintaion
}

class HomeViewController: UIViewController, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate {
    
    /// Mapview object
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnSource: UIButton!
    @IBOutlet weak var btnDestination: UIButton!

    var mapModel = MapModel()
    var locationManager = CLLocationManager()
    var isSourceOrDestination: Bool = false //false - source, true - destination
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        mapView.isMyLocationEnabled = true
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @IBAction func signoutAction(_ sender: Any) {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func getCurrentLocAction(_ sender: Any) {
        self.locationManager.startUpdatingLocation()
    }
    
    @IBAction func sourceDestinationAction(_ sender: Any) {
        let button = sender as! UIButton
        
        switch button.tag {
        case ButtonType.Source.rawValue:
            print("source button")
            isSourceOrDestination = false
        case ButtonType.Destintaion.rawValue:
            print("destination button")
            isSourceOrDestination = true
        default:
            print("default case")
        }
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    /// Load google map on screen
    func loadCameraView() {
        
        SVProgressHUD.show()
        
        Webservice.webServiceGetRouteCoordinates(mapModel, { (success, responseDictionary, error) in
            
            SVProgressHUD.dismiss()
            
            var bounds = GMSCoordinateBounds()
            
            if success && (responseDictionary != nil)
            {
//                print("responseDictionary \(responseDictionary!)")
                
                let routes = responseDictionary?.value(forKey: "routes") as! [AnyObject]
                
                if routes.count > 0
                {
                    let polyline = routes[0].value(forKey: "overview_polyline") as AnyObject
                    let points = polyline.value(forKey: "points") as! String
                    
                    let cameraPosition = GMSCameraPosition.camera(withLatitude: self.mapModel.sourceLatitude!, longitude: self.mapModel.sourceLongitude!, zoom: 13)
                    let mapView = GMSMapView.map(withFrame: self.mapView.bounds, camera: cameraPosition)
                    mapView.isMyLocationEnabled = true
                    mapView.accessibilityElementsHidden = false
                    
                    //Add marker
                    let sourcePosition = CLLocationCoordinate2DMake(self.mapModel.sourceLatitude!, self.mapModel.sourceLongitude!)
                    let markerSource = GMSMarker(position: sourcePosition)
                    markerSource.map = mapView
                    markerSource.title = self.mapModel.sourceTitle
                    bounds = bounds.includingCoordinate(markerSource.position)
                    
                    let destinationPosition = CLLocationCoordinate2DMake(self.mapModel.destinationLatitude!, self.mapModel.destinationLongitude!)
                    let markerDestination = GMSMarker(position: destinationPosition)
                    markerDestination.icon = GMSMarker.markerImage(with: UIColor.green)
                    markerDestination.map = mapView
                    markerDestination.title = self.mapModel.destinationTitle
                    bounds = bounds.includingCoordinate(markerDestination.position)
                    
                    let path = GMSPath.init(fromEncodedPath: points)
                    //GMSPath.fromEncodedPath(parsedData["routes"][0]["overview_polyline"]["points"].string!)
                    let singleLine = GMSPolyline.init(path: path)
                    singleLine.strokeWidth = 3
                    singleLine.strokeColor = UIColor.red
                    singleLine.map = mapView
                    self.mapView.addSubview(mapView)
                    self.mapView.bringSubview(toFront: self.btnCurrentLocation)
                    
                    let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                    mapView.animate(with: update)
                    
                }else
                {
                    CustomAlertView.showNegativeAlert(NSLocalizedString("ALERT_SERVER_ERROR", comment: ""))
                }
            }
        })
    }
    
    //MARK: Google autocomplete delegate methods
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        //        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        //        self.googleMapsView.camera = camera
        
        if !isSourceOrDestination {
            mapModel.sourceLatitude = place.coordinate.latitude
            mapModel.sourceLongitude = place.coordinate.longitude
            
            btnSource.setTitle("  \(mapModel.sourceLatitude!),\(mapModel.sourceLongitude!)", for: .normal)

        }else {
            mapModel.destinationLatitude = place.coordinate.latitude
            mapModel.destinationLongitude = place.coordinate.longitude
            
            btnDestination.setTitle("  \(mapModel.destinationLatitude!),\(mapModel.destinationLongitude!)", for: .normal)
        }
        
        loadCameraView()
        self.dismiss(animated: true, completion: nil) // dismiss after select place
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
    }
    
    
    //MARK:- Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        mapModel.sourceLatitude = location?.coordinate.latitude
        mapModel.sourceLongitude = location?.coordinate.longitude
        
        btnSource.setTitle("  \(mapModel.sourceLatitude!),\(mapModel.sourceLongitude!)", for: .normal)
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        
        self.mapView?.animate(to: camera)
        
        if mapModel.sourceLatitude != nil && mapModel.sourceLongitude != nil && mapModel.destinationLatitude != nil && mapModel.destinationLongitude != nil {
            loadCameraView()
        }
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
