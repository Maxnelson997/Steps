//
//  Extension.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

enum CustomFont: String {
    case MavenProRegular = "MavenPro-Regular"
    case MavenProBlack = "MavenPro-Black"
    case MavenProBold = "MavenPro-Bold"
    case MavenProMedium = "MavenPro-Medium"
    
    
    case ProximaNovaLight = "ProximaNova-Regular"
    case ProximaNovaThin = "ProximaNovaT-Thin"
    case ProximaNovaRegular = "ProximaNova-Light"
    case ProximaNovaSemibold = "ProximaNova-Semibold"
}

extension UIFont {
    convenience init?(customFont: CustomFont, withSize size: CGFloat) {
        self.init(name: customFont.rawValue, size: size)
    }
}

extension UIColor {
    
    open class var MNDarkGray: UIColor { return UIColor.init(rgb: 0x1C1D1D) } //0x232323 //0x1D1D1D
    open class var MNGray: UIColor { return UIColor.init(rgb:  0x292A2A) } //0x525252 //0x383939
    open class var MNOriginalDarkGray: UIColor { return UIColor.init(rgb: 0x232323) }
    open class var MNGreen: UIColor { return UIColor.init(rgb: 0x5CFF90) }
    open class var MNBlue: UIColor { return UIColor.init(rgb: 0x7ECDFD) }
    open class var MNTextGray: UIColor { return UIColor.init(rgb: 0xFEFDFE) }
    open class var MNMagenta: UIColor { return UIColor.init(rgb: 0xEC34FF) }
    

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView {
    func addDropShadowToView(){
        self.layer.masksToBounds =  false
        self.layer.shadowColor = UIColor.darkGray.cgColor;
        self.layer.shadowOffset = CGSize(width: 8.0, height: 11.0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5
    }
}

extension UILabel {
    convenience init(withFont: UIFont) {
        self.init(frame: .zero)
        self.font = withFont
    }
    
    func animate(toText:String) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { finished in
            self.text = toText
            UIView.animate(withDuration: 0.35, animations: {
                self.alpha = 1
            })
        })
    }
}

extension UITextField {
    func animate(toText:String) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { finished in
            self.text = toText
            UIView.animate(withDuration: 0.35, animations: {
                self.alpha = 1
            })
        })
    }
    
    func moveTextField(inView: UIView, moveDistance: Int, up: Bool)
    {
        let moveDuration = 0.3
        //movement similar to isset in php. if up true + if !up true -
        let movement: CGFloat = CGFloat(up ? -moveDistance : moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        //animated way
        UIView.setAnimationBeginsFromCurrentState(true)
        //completion timer
        UIView.setAnimationDuration(moveDuration)
        //
        inView.frame = inView.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}

extension UIView {
    func getConstraintsOfView(to: UIView) -> [NSLayoutConstraint] {
        return [
            self.leftAnchor.constraint(equalTo: to.leftAnchor),
            self.rightAnchor.constraint(equalTo: to.rightAnchor),
            self.bottomAnchor.constraint(equalTo: to.bottomAnchor),
            self.topAnchor.constraint(equalTo: to.topAnchor)
        ]
    }
    func constrainTo(view: UIView, withInsets:UIEdgeInsets) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: withInsets.left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -1*(withInsets.right)),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: withInsets.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1*(withInsets.bottom
                ))
            ])
    }
    
    func getConstraintsTo(view: UIView, withInsets:UIEdgeInsets) -> [NSLayoutConstraint] {
        print(withInsets)
        
        return [
            
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: withInsets.left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -1*(withInsets.right)),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: withInsets.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1*(withInsets.bottom
                ))
        ]
    }
}

struct ViewMultiplier {
    var view:UIView!
    var multiplier:CGFloat!
}
extension UIStackView {
    func addViewsWithCons(direction: [StackViewDirection], views:[ViewMultiplier]) -> [NSLayoutConstraint] {
        
        if direction.contains(.vertical) {
            self.axis = .vertical
        } else {
            self.axis = .horizontal
        }
        
        var cons:[NSLayoutConstraint] = []
        var total:CGFloat = 0.0
        
        for v in views {
            self.addArrangedSubview(v.view)
            total += v.multiplier
            if direction.contains(.vertical) {
                cons.append(v.view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: v.multiplier))
            } else if direction.contains(.horizontal) {
                cons.append(v.view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: v.multiplier))
            }
        }
        if total == 0 {
            fatalError("Missing either StackViewDirection option or multiplier values")
        } else if total != 1 {
            fatalError("multipliers do not add up to 1. Multipliers need to be equal to 1 when combined, in order to fill the StackView")
        } else {
            print("Arranged subviews added to StackView with generated constraints successfully")
            return cons
        }
        
    }
    
    func addCons(direction: [StackViewDirection], views:[ViewMultiplier]) -> [NSLayoutConstraint] {
        
        var cons:[NSLayoutConstraint] = []
        var total:CGFloat = 0.0
        
        for v in views {
           
            total += v.multiplier
            if direction.contains(.vertical) {
                cons.append(v.view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: v.multiplier))
            } else if direction.contains(.horizontal) {
                cons.append(v.view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: v.multiplier))
            }
        }
        if total == 0 {
            fatalError("Missing either StackViewDirection option or multiplier values")
        } else if total != 1 {
            fatalError("multipliers do not add up to 1. Multipliers need to be equal to 1 when combined, in order to fill the StackView")
        } else {
            print("Arranged subviews added to StackView with generated constraints successfully")
            return cons
        }
        
    }
}

extension UIImageView {
    convenience init(image:UIImage, rect:CGRect) {
        self.init(frame: rect)
        self.tintColor = UIColor.MNTextGray
        self.image = image.withRenderingMode(.alwaysTemplate)
    }
}
