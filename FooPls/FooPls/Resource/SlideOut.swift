//
//  SlideLeft.swift
//  FooPls
//
//  Created by ilhan won on 2017. 12. 12..
//  Copyright © 2017년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class SlideLeft: UIStoryboardSegue {
    override func perform() {
        let source = self.source
        let destination = self.destination
    
        source.view.superview?.insertSubview(destination.view, aboveSubview: source.view)
        destination.view.transform = CGAffineTransform(translationX: -source.view.frame.width, y: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0.1,
                       options: .curveEaseInOut, animations: {
            destination.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finished) in
            source.present(destination, animated: false, completion: nil)
        }
    }
}

class SlideRight: UIStoryboardSegue {
    override func perform() {
        let source = self.source
        let destination = self.destination
        
        source.view.superview?.insertSubview(destination.view, aboveSubview: source.view)
        destination.view.transform = CGAffineTransform(translationX: source.view.frame.width, y: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0.1,
                       options: .curveEaseInOut, animations: {
            destination.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finished) in
            source.present(destination, animated: false, completion: nil)
        }
    }
}

