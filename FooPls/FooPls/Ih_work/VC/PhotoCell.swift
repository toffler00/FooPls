
import UIKit

class PhotoCell: UICollectionViewCell {
    let photoImgView : UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        imgV.backgroundColor = UIColor.lightGray
        return imgV
    }()
    let photoBtn : UIButton = {
        let btn = UIButton()
        btn.isSelected = false
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImgView)
        photoImgView.translatesAutoresizingMaskIntoConstraints = false
        photoImgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        photoImgView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
        photoImgView.addSubview(photoBtn)
        photoBtn.translatesAutoresizingMaskIntoConstraints = false
        photoBtn.topAnchor.constraint(equalTo: photoImgView.topAnchor).isActive = true
        photoBtn.bottomAnchor.constraint(equalTo: photoImgView.bottomAnchor).isActive = true
        photoBtn.rightAnchor.constraint(equalTo: photoImgView.rightAnchor).isActive = true
        photoBtn.leftAnchor.constraint(equalTo: photoImgView.leftAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
