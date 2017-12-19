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
    
    //GooglePlacePickerDataCenter 진행
    var dataCenter = DataCenter()
    
    
    @IBOutlet weak var placeLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView:UITextView?
    var ref:DatabaseReference!
    
    //Delegate 관련 업로드 자료
    var adress:String = DataCenter.main.placeAddress
    var placeName:String = DataCenter.main.placeName
    var latitude:Double = DataCenter.main.latitude
    var longitudue:Double = DataCenter.main.longitude
    
    
    
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
        
        DataCenter.main.placeAddress = adress
        DataCenter.main.latitude = latitude
        DataCenter.main.longitude = longitudue
        DataCenter.main.placeName = placeName
        
        dismiss(animated: true, completion: nil)
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
        
        placeLB.text = placeName
        addressLB.text = adress
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
        self.navigationController?.navigationBar.tintColor = .black
        
    }
    
    
    
    
    @IBAction func dismissBtn(_ sender: UIBarButtonItem) {
        
        //데이터 저장.
        //delegate?.positinData(lati: latitude!, longi: longitudue!, address: adress!, placeName: placeName!)
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension SK_AutoSearchViewController : GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        
        addressLB.textAlignment = .center
        placeLB.text = place.name
        
        
        shortAddress(addressTracker: place.formattedAddress!)
        
        addressLB.text = adress

        
        placeName = place.name
        latitude = place.coordinate.latitude
        longitudue = place.coordinate.longitude
        

        
        showSearchResult(lati: place.coordinate.latitude, longi: place.coordinate.longitude, placeName: place.name)
        
        //"대한민국 서울특별시 강남구 신사동 ~~~"
        
        
    
    }
    
    func shortAddress(addressTracker: String) -> String {
        
        let fullAddress = addressTracker
        let fullAddressArr = fullAddress.components(separatedBy: " ")
        
        self.adress = fullAddressArr[1] + " " + fullAddressArr[2] + " " + fullAddressArr[3]
        print(self.adress)
        
        return adress
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error : ", error.localizedDescription)
        
    }
}

protocol GooglePlaceDataDelegate {
    
    func positinData(lati: Double, longi: Double, address:String, placeName:String)
    
}
