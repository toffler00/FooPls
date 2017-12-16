//
//  ImagePickerVC.swift
//  FooPls
//
//  Created by ilhan won on 2017. 12. 14..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit
import Photos
protocol ImagePickerDelegate {
    func photoSelected(_ seletedImges : UIImage)
}


private let reuseIdentifier = "PhotoCell"

class ImagePickerVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Delegate
    var delegate : ImagePickerDelegate?

    //MARK: Variable
    var selectImg : UIImage?
    var photos = [UIImage]()
    var assets = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPhotoLibray()
        setUpAndRegister()
        setNavigationbar()
        
        
    }
    
    //MARK: fetchassets Option
   fileprivate func fetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        return fetchOptions
    }

    //MARK: load photo library
    func loadPhotoLibray() {
        let allphoto = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        DispatchQueue.global().async {
            allphoto.enumerateObjects({ (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.photos.append(image)
                        self.assets.append(asset)
                        if self.selectImg == nil {
                            self.selectImg = image
                        }
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            })
        }
    }
    
   

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        cell.photoImgView.image = photos[indexPath.item]
       
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: reuseIdentifier,
                                                                     for: indexPath) as! PhotoCell
        
        header.photoImgView.image = selectImg
        
        if let selectImg = selectImg {
            if let index = self.photos.index(of: selectImg) {
                let selectasset = self.assets[index]
                let size = CGSize(width: 608, height: 608)
                PHImageManager.default().requestImage(for: selectasset, targetSize: size,
                                                      contentMode: PHImageContentMode.aspectFit,
                                                      options: nil, resultHandler: { (image, info) in
                    header.photoImgView.image = image
                    self.selectImg = image
                })
            }
        }
        
        return header
    }
    
    //MARK : CollectioView layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        let size = CGSize(width: width, height: width )
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    
    
    // MARK: UICollectionViewDelegate

//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectImg = photos[indexPath.item]
        self.collectionView?.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
extension ImagePickerVC {
    func setUpAndRegister() {
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(PhotoCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
    }
    
    func setNavigationbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음",
                                                            style: .plain, target: self,
                                                            action: #selector(handleDone))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소",
                                                           style: .plain, target: self,
                                                           action: #selector(handleCancle))

    }
    
    @objc func handleDone() {
        if let selectImg = selectImg {
            self.delegate?.photoSelected(selectImg)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else {
            let alertMessage = "사진을 선택하세요."
            UIAlertController.presentAlertController(target: self, title: "경고", massage: alertMessage , actionStyle: .default, cancelBtn: false, completion: nil)
        }
    }
    
    @objc func handleCancle() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
