//
//  AutoSearchViewController.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 7..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SK_AutoSearchViewController: UIViewController {
    
    @IBOutlet weak var placeLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView:UITextView?
    var ref:DatabaseReference!
    
    @IBOutlet var googleMapView: GMSMapView!
    var zoom:Float = 14
    var marker:GMSMarker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        makeGoogleSearchBar()
        startGoogleMap()
        view.backgroundColor = UIColor(red: 248/255, green: 239/255, blue: 106/255, alpha: 1)
        
        

        
    }
    
    @IBAction func postToFirebase(_ sender: Any) {
        
    }
    
    func startGoogleMap(){
        
        
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.515, longitude: 127.019, zoom: zoom)
        self.googleMapView.camera = camera
        
        let marker = GMSMarker()
        marker.map = googleMapView
        marker.position = camera.target
        marker.icon = UIImage(named: "GMarker")
        marker.snippet = "FooPls Center"
        
        placeLB.text = "FooPls Center"
        addressLB.text = "서울시 강남구 신사동"
        
    }
    
    func showSearchResult(lati: Double, longi:Double, placeName:String){
        
        googleMapView.clear()
        
        let camera = GMSCameraPosition.camera(withLatitude: lati, longitude: longi, zoom: zoom)
        self.googleMapView.camera = camera
        
        let marker = GMSMarker()
        marker.map = googleMapView
        marker.position = camera.target
        marker.snippet = placeName
        marker.icon = UIImage(named: "GMarker")
        
    }
    
    func makeGoogleSearchBar(){
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
        
        //self.navigationController?.navigationBar.backgroundColor = UIColor.blue
        //self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 248, green: 239, blue: 106, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 248/255, green: 239/255, blue: 106/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        //self.navigationController?.navigationItem.setRightBarButton(UIBarButtonItem, animated: true)
    }
    
    @IBAction func searchForGoogleBtn(_ sender: UIButton) {
        
        
        
        
        
    }
    
    
}

extension SK_AutoSearchViewController : GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        
        placeLB.text = place.name
        addressLB.text = place.formattedAddress
        
        
        showSearchResult(lati: place.coordinate.latitude, longi: place.coordinate.longitude, placeName: place.name)
        
        
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error : ", error.localizedDescription)
        
    }
    
    
    
    
    
}
