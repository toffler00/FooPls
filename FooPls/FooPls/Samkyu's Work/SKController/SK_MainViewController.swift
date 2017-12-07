//
//  SK_MainViewController.swift
//  FooPls
//
//  Created by Samuel K on 2017. 12. 5..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit
import GooglePlaces


class SK_MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var titleLB:String?
    var ImgView:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 10) / 2
        let height = view.frame.size.height / 3
        let layoutSize = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layoutSize.itemSize = CGSize(width: width, height: height)
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailView" {
            if let dest = segue.destination as? SK_DetailViewController {
                
                dest.nameTitle = titleLB
                dest.postedImage = ImgView
            }
            
        }
        
    }

    @IBAction func searchForGoogleBtn(_ sender: Any) {
        
        
    }
    
}


//구글 맵 로딩 익스텐션 설정
//extension SK_MainViewController:   {
//    
//}


extension SK_MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "SK_MainViewController", for: indexPath) as! SK_CollectionViewCell
        
        self.titleLB = item.titleLB.text
        self.ImgView = item.uploadedImageVIew.image
        
        
        return item
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailView", sender: nil)
        
    }
    
    
}
