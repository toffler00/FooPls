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
    var searchedPlaces:[AddressData] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("리로드 됩니다!")
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
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
        
        searchedPlaces = []
        
        //let downloadData = SearchedData(data: place.name)
        let data = SearchedData()
        data.loadToFirebase(address: place.name) { (downloadData) in
            print(downloadData)
            for data in downloadData {
                self.searchedPlaces.append(data)
                print("여기에 안들어가나? :", self.searchedPlaces)
            }
            self.tableView.reloadData()
        }
        
        
        
        
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error : ", error.localizedDescription)
        
    }
    
    
    
}

extension SK_SearchListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rows = searchedPlaces.count
        print("서치에서 실행되는중 ! : rows", rows)
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let downloadrows = searchedPlaces[indexPath.row]
        print("서치에서 실행되는중 ! : downloadrows", downloadrows)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SearchResultTableViewCell
        
        cell?.usernameLB.text = downloadrows.username
        cell?.addressNameLB.text = downloadrows.placeName
        cell?.commentLB.text = downloadrows.comment
        
        //dispathQue로 돌리기
        DispatchQueue.global().async {
            let imageURLStr:String = downloadrows.photoUrl!
            let imageURL:URL = URL(string: imageURLStr)!
            let imageData:NSData = NSData(contentsOf: imageURL)!
            
            DispatchQueue.main.async {
                cell?.uploadedImage.image = UIImage(data: (imageData as? Data)!)
            }
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let heightForRow:CGFloat = 80
        
        return heightForRow
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "SKMain", bundle: nil)
        let specificVC = storyboard.instantiateViewController(withIdentifier: "SK_SpecifiPostViewController") as? SK_SpecifiPostViewController
        
        //        var postingIndex: String = ""
        //        var date: String?
        //        var longitude: Double?
        //        var latitude: Double?
        //        var address: String?
        //        var selectedKey: String?
        //        var photoName: String?
        
        let rowsIndex = searchedPlaces[indexPath.row]
        print("rowsIndex", rowsIndex)
        
        specificVC?.date = rowsIndex.writtenDate
        specificVC?.postingIndex = rowsIndex.placeName!
        specificVC?.address = rowsIndex.placeAddress
        specificVC?.comment = rowsIndex.comment
        specificVC?.thought = rowsIndex.content
        
        DispatchQueue.global().async {
            let imageURLStr:String = rowsIndex.photoUrl!
            let imageURL:URL = URL(string: imageURLStr)!
            let imageData:NSData = NSData(contentsOf: imageURL)!
            
            DispatchQueue.main.async {
                specificVC?.detailImage = UIImage(data: imageData as Data)
                self.present(specificVC!, animated: true, completion: nil)
            }
        }
    }
    
}
