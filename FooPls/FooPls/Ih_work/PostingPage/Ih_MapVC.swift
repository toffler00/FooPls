//
//  ViewController.swift
//  FooplsProject
//
//  Created by ilhan won on 2017. 11. 28..
//  Copyright © 2017년 ilhan won. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit

class MapVC: UIViewController, GMSMapViewDelegate, UITextFieldDelegate{
    
    //IBOutlet
    @IBOutlet weak var zoomStepper: UIStepper!
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var locationTitleTF: UITextField!
    
    
    var mapView : GMSMapView!
    private var marker : GMSMarker!
    var mapAdress: GMSAddress!
    let dataCenter : DataCenter? = nil
    //default value
    var latitude : Double  = 37.578
    var longitude : Double = 126.976
    var locationTitle : String? = "경복궁"
    var zoom : Float = 13
    var textfield : UITextField?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepperSetting()
        mapView = GMSMapView()
        showMap(latitude: latitude, longitude: longitude, title: locationTitle!, zoom: zoom)
        
        //mapView Delegate
        mapView.delegate = self
        
        //textfield Delegate
        latitudeTF.delegate = self
        longitudeTF.delegate = self
        longitudeTF.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func loadPositionData() {
        
        
       dataCenter?.load(completion: { positions in //completion 클로저의 [Position]을 positions 라는 파라미터로 받아 실행.
            for position in positions {
                self.showMap(latitude: position.latitude, longitude: position.longitude, title: position.title, zoom: self.zoom)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("end")
        self.view.endEditing(true)
        return true
    }
    
    //텍스트필드의 입력값을 더블로 변환시켜주는 함수
    func toDouble(fromString : String) -> Double? {
        return NumberFormatter().number(from: fromString)?.doubleValue
    }
    
    //확인버튼 눌렀을 때 지정한 곳으로 이동
    @IBAction func selectLocation(_ sender: Any) {
        //        let lati = toDouble(fromString: latitudeTF.text!)
        //        let longi = toDouble(fromString: longitudeTF.text!)
        //
        //        showMap(latitude: lati!, longitude: longi!, title: locationTitle!, zoom: self.zoom)
        self.loadPositionData()
    }
    
    //change zoom value
    @IBAction func changeZoom(_ sender : UIStepper) {
        let zoomV : Float = Float(zoomStepper.value)
        self.zoom = zoomV
        mapView.animate(toZoom: zoomV)
    }
    
    //showMap
    func showMap(latitude : Double, longitude : Double, title: String, zoom : Float) {
        
        mapView.frame = CGRect(x: 0, y: 30,
                               width: self.view.bounds.width,
                               height: self.view.bounds.height / 2)
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: self.zoom)
        
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker = GMSMarker(position: position)
        marker.title = title
        marker.snippet = "눌러봐"
        marker.map = mapView
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.isTappable = true
        self.view.addSubview(mapView)
    }
    
    //didTap marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let detailVC = DetailInfoVC() //DetailInfoVC 인스턴스 생성 : 추후 marker에 해당하는 음식점 정보를 넘길 예정

        detailVC.titleLB.text = marker.title
        
        let positions = marker.position //marker 의 포지션 정보를 가져와서 DetailInfoVC의 Label에 전달.
        detailVC.latitudeLB.text = String(positions.latitude)
        detailVC.longitudeLB.text = String(positions.longitude)
        self.navigationController?.pushViewController(detailVC, animated: true)
        return true
    }
    
    //stepper setting
    func stepperSetting() {
        zoomStepper.value = 13
        zoomStepper.minimumValue = 1
        zoomStepper.maximumValue = 20
        zoomStepper.stepValue = 1
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
}


