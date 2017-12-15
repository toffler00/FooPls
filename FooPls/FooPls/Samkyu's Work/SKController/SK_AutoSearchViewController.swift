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
    
    var delegate : GooglePlaceDataDelegate?
    
    
    @IBOutlet weak var placeLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView:UITextView?
    var ref:DatabaseReference!
    
    //Delegate 관련 업로드 자료
    var adress:String?
    var placeName:String?
    var latitude:Double?
    var longitudue:Double?
    
    
    
    @IBOutlet var googleMapView: GMSMapView!
    var zoom:Float = 14
    var marker:GMSMarker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        makeGoogleSearchBar()
        startGoogleMap()
        view.backgroundColor = UIColor(red: 250/255, green: 239/255, blue: 75/255, alpha: 1)
        
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
        addressLB.textAlignment = .center
        
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
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    
    
    
    
    @IBAction func dismissBtn(_ sender: UIBarButtonItem) {
        
        //데이터 저장.
        delegate?.positinData(lati: latitude!, longi: longitudue!, address: adress!, placeName: placeName!)
        dismiss(animated: true, completion: nil)
        
        
    }
    
}

extension SK_AutoSearchViewController : GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        
        addressLB.textAlignment = .left
        placeLB.text = place.name
        addressLB.text = place.formattedAddress
        
        adress = place.formattedAddress
        placeName = place.name
        latitude = place.coordinate.latitude
        longitudue = place.coordinate.longitude
        
        showSearchResult(lati: place.coordinate.latitude, longi: place.coordinate.longitude, placeName: place.name)
        
    
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error : ", error.localizedDescription)
        
    }
}

protocol GooglePlaceDataDelegate {
    
    func positinData(lati: Double, longi: Double, address:String, placeName:String)
    
}
