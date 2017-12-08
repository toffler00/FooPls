//
//  SK_PostDataModel.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 7..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import Foundation


class PostDataModel {
    
    var placeName:String
    var address:String
    var lati:Double
    var longi:Double
    
    init(place: String, address: String, lati:Double, longi:Double) {
        placeName = place
        self.address = address
        self.lati = lati
        self.longi = longi
    }
}
