//
//  SK_SearchListViewController.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 19..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SK_SearchListViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView:UITextView?
    var zoom:Float = 14
    
    var adress:String = DataCenter.main.placeAddress
    var placeName:String = DataCenter.main.placeName
    var latitude:Double = DataCenter.main.latitude
    var longitudue:Double = DataCenter.main.longitude
    
    var ref: DatabaseReference!
    
    var sampleData:SearchedData?
    
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        makeGoogleSearchBar()
        startGoogleMap()
        
        findInFirebaseDatabase()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        sampleData = SearchedData()
        print(sampleData)
        
    }
    
    func startGoogleMap(){
        
        
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitudue, zoom: zoom)
        self.googleMapView.camera = camera
        
        let marker = GMSMarker()
        marker.map = googleMapView
        marker.position = camera.target
        marker.icon = UIImage(named: "GMarker")
        marker.snippet = placeName
        
        
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
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 248/255, green: 239/255, blue: 106/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .black
        
    }
    
    func findInFirebaseDatabase(){
        
        let isSearchedAddress = ref.child("users").queryEqual(toValue: "FooPls!")
        print("결과값 확인하세요! : ", isSearchedAddress)
        
        
        
        
    }
    
}

extension SK_SearchListViewController : GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        print("필요한 정보를 습득하십시오.")
        
        searchController?.isActive = false
        showSearchResult(lati: place.coordinate.latitude, longi: place.coordinate.longitude, placeName: place.name)
        
        
        
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error : ", error.localizedDescription)
        
    }
    
    
    
}

extension SK_SearchListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
        
    }
    
}
