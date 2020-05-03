//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Vera on 16.02.2020.
//  Copyright © 2020 Vera. All rights reserved.
//


import UIKit

struct Channel: Equatable {
    let identifier: String
    let name: String?
    let lastMessage: String?
    let lastActivity: Date?
}

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure (with model: ConfigurationModel)
}

extension UIColor{
    //softpink
    static let mainColor = UIColor(red:0.38, green:0.49, blue:0.55, alpha:1.0)//UIColor(red:0.67, green:0.62, blue:0.64, alpha:1.0)
    static let mainLightColor = UIColor(red:0.38, green:0.49, blue:0.55, alpha:0.2)
    //static let mainLightColor = UIColor(red:0.90, green:0.85, blue:0.85, alpha:1.0)
    
    static let yellowLight = UIColor(red:1.00, green:1.00, blue:0.55, alpha:1.0)
    static let deepBlue = UIColor(red:0.10, green:0.33, blue:0.48, alpha:0.5)
    
    //#d299c2→#fef9d7 wild apple
    static let pink = UIColor(red:0.82, green:0.60, blue:0.76, alpha:1.0)
    static let greyYellow = UIColor(red:1.00, green:0.98, blue:0.84, alpha:1.0)
    
    //Turkish palet
    static let unmellowYellow = UIColor(red:1.00, green:0.98, blue:0.40, alpha:1.0)
    static let balticSea = UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.0)
    static let blueGrey500 = UIColor(red:0.38, green:0.49, blue:0.55, alpha:1.0)
    static let blueGrey800 = UIColor(red:0.22, green:0.28, blue:0.31, alpha:1.0)
    static let blueGrey900 = UIColor(red:0.15, green:0.20, blue:0.22, alpha:1.0)
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

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }
        
        return self
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

class UnderlinedLabel: UILabel {

override var text: String? {
    didSet {
        guard let text = text else { return }
        let textRange = NSMakeRange(0, text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        // Add other attributes if needed
        self.attributedText = attributedText
        }
    }
}

func stringFromAny(_ value:Any?) -> String {
    if let nonNil = value, !(nonNil is NSNull) {
        return String(describing: nonNil)
    }
    return ""
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
