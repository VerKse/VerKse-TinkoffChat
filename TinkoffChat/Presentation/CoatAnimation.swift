//
//  CoatAnimation.swift
//  TinkoffChat
//
//  Created by Вера Ксенофонтова on 26.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit

class CoatAnimation{
    
    var view: UIView
    
    let longGestureRecognizer = UILongPressGestureRecognizer()
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    required init(viewController: UIGestureRecognizerDelegate, view: UIView) {
        self.view = view
        
        panGestureRecognizer.addTarget(self, action: #selector(self.tapAction(_:)))
        longGestureRecognizer.addTarget(self, action: #selector(self.longAction(_:)))
        longGestureRecognizer.delegate = viewController
        panGestureRecognizer.delegate = viewController
        self.view.addGestureRecognizer(panGestureRecognizer)
        self.view.addGestureRecognizer(longGestureRecognizer)
    }
    
    @objc func tapAction(_ gestureRecognizer: UIPanGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.view)
        animateAt(touchPoint: touchPoint)
    }
    
    @objc func longAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.view)
        animateAt(touchPoint: touchPoint)
    }
    
    func animateAt (touchPoint: CGPoint){
        let rnd = Int.random(in: -5..<5)
        let rndRotation = Int.random(in: -4..<4)
        let coat = UIImageView(frame: CGRect(x: touchPoint.x+CGFloat(rnd), y: touchPoint.y+CGFloat(rnd), width: 40, height: 40))
        coat.image = UIImage(named: "logo.png")
        view.addSubview(coat)
        UIView.animateKeyframes(withDuration: 0.7,
                                delay: 0.0,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.1,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        coat.transform =
                                                            CGAffineTransform(rotationAngle: -.pi / CGFloat(rndRotation))
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        coat.center.x += CGFloat(rnd)*5.0
                                                        coat.center.y -= CGFloat(rnd)*5.0
                                    })
        },
                                completion:  {(completed) in coat.removeFromSuperview()
        })
    }
}
