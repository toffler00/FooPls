//
//  AutoSearchViewController.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 7..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit
import GooglePlaces
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
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        makeGoogleSearchBar()
        
        
    
        
        
    }
    
    @IBAction func postToFirebase(_ sender: Any) {
        
        
        
        
        
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
        
        
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        
        print("Error : ", error.localizedDescription)
        
    }
    
    
    
    
    
}
