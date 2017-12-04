//
//  MapDataCenter.swift
//  (1126)GoogleMapsSample
//
//  Created by Samuel K on 2017. 11. 30..
//  Copyright © 2017년 Samuel K. All rights reserved.
//

import Foundation

// Firebase 관련 Tool을 import합니다.
import Firebase
import FirebaseStorage
import FirebaseDatabase

//Firebase를 사용하기 위하여, database를 생성하는 변수를 선언한다.

var ref: DatabaseReference!

//위도 경도를 각 지점 별로 받는 Struct문을 작성한다.

struct Position {

    //외부에서 수정이 불가능 하도록, Private를 설정한다. 실제 가져올 데이터는 get-only 로 처리되도록 구현.
    private let Reallati:Double?
    private let Reallongi:Double?
    
    var lati:Double? {
        return Reallati
    }
    
    var longi:Double? {
        return Reallongi
    }
    
    
    init?(data: [String:Any]) {
        //guard-let 구문을 이용하여, 딕셔너리의 Data를 입력하여 주는 작업을 진행한다.
        guard let lati = data["lati"] as? Double else { return nil }
        Reallati = lati
        guard let longi = data["longi"] as? Double else { return nil }
        Reallongi = longi
    }
}

//Firebase에서 Data를 가져와서 데이터 모델을 가지는 클래스를 생성하여 준다.

class PositionData {
    //해당 Data를 싱글턴 패턴으로 전환하여 설정한다.
    //싱글턴 패턴으로 진행하여야 맵에 해당 위치를 받을 수 있는 상황이 된다.(Firebase 자료 Reading시 시간이 소요됨)
    
    //싱글턴 패턴을 구현한다.
    static var main = PositionData()
    
    var positionDatas:[Position] = []
    
    
    //privateInit을 진행하여 자동으로 맵에서 로딩이 되도록 한다.
    //추후 속도개선을 위해, 싱글턴 패턴을 해제하고 하는 방법을 찾아보도록 한다.
    private init(){
        
        loadData()
        
    }
    
    //firebase에서 특정 Data를 가지고 오는 메소드를 구현한다.
    func loadData(){
        
        //데이터 베이스르를 가져오는 인스턴스를 생성한다.
        ref = Database.database().reference()
        
        //ref인스턴스에서 Key값을 조회하여, 1차적으로 전체 데이터를 가져온다.
        ref.child("latiAndLongi").observe(.value) { (entireData) in
            
            //entireData를 Swift에서 인식이 가능한 형태로 형변환을 하여준다.
            if let dataBase = entireData.value as? [String:Any] {
                
                //dataBase에서 랜덤으로 배정된(AutoID) 값을 조회할 수 있는 상태로 전환한다.
                //각각 하나의 랜덤 키값을 가지고 있으므로, for문을 사용하여 해당 값을 처리하여 준다.
                
                for index in dataBase {
                    //각각의 AutoID를 추출한다.
                    let autoID = index.key
                    //각각의 AutoID를 기준으로 하여, 한번더 firebase로부터 datareading을 시도한다.
                    ref.child("latiAndLongi").child(autoID).observe(.value, with: { (eachData) in
                        
                        //각 데이터(lati, longi)를 저장할 테이터를 확인하는 작업을 진행한다.
                        if let currentLocation = eachData.value as? [String:Any] {
                            //currentLocation 의 변수를 Positon Struct로 초기화 하여 준후, 현재 Class의 배열에 하나씩 append하여 준다.
                            
                            if let eachPosition = Position(data: currentLocation) {
                                self.positionDatas.append(eachPosition)
                            }
                        }
                    })
                }
            }
        }
    }
}




