//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Vera on 16.02.2020.
//  Copyright © 2020 Vera. All rights reserved.
//


import UIKit

extension UIColor{
    //softpink
    static let mainColor = UIColor(red:0.67, green:0.62, blue:0.64, alpha:1.0)
    static let mainLightColor = UIColor(red:0.90, green:0.85, blue:0.85, alpha:1.0)
    
    static let yellowLight = UIColor(red:0.98, green:1.00, blue:0.82, alpha:1.0)
    static let deepBlue = UIColor(red:0.10, green:0.33, blue:0.48, alpha:1.0)
    
    //#d299c2→#fef9d7 wild apple
    static let pink = UIColor(red:0.82, green:0.60, blue:0.76, alpha:1.0)
    static let greyYellow = UIColor(red:1.00, green:0.98, blue:0.84, alpha:1.0)
}

extension UIFont{

    class Play {
        let Bold = UIFont(name: "Play-Bold", size: UIFont.labelFontSize)
        let Regular = UIFont(name: "Play-Regular", size: UIFont.labelFontSize)
    }
    
    class RobotoSlab{
        let ExtraLight = UIFont(name: "RobotoSlab-ExtraLight", size: UIFont.labelFontSize)
        let Light = UIFont(name: "RobotoSlab-Light", size: UIFont.labelFontSize)
        let Thin = UIFont(name: "RobotoSlab-Thin", size: UIFont.labelFontSize)
    }
}

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure (with model: ConfigurationModel)
}
