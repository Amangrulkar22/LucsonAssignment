//
//  CustomAlertView.swift
//  LucsonAssignment
//
//  Created by Ashwinkumar Mangrulkar on 26/06/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
/// Custome AlertView Class
@objc class CustomAlertView: UIAlertController
{
    @available(iOS 8.0, *)
    
    /// Function to SHow Positive AlertView
    ///
    /// - Parameter message: Message of AlertView
    class func showPositiveAlert(_ message:String)
    {
        self.showAlert(0, textColor: 1, message: message)
    }
    /// FUnction to show Negative AlertView
    ///
    /// - Parameter message: Message of AlertView
    class func showNegativeAlert(_ message:String)
    {
        self.showAlert(0, textColor: 2, message: message)
    }
    /// Function to Show Warning AlertView
    ///
    /// - Parameter message: Mesasage of AlertView
    class func showWarningAlert(_ message:String)
    {
        self.showAlert(0, textColor: 3, message: message)
    }
    /// Function to Show AlerView and it it Private Methdod
    class fileprivate func showAlert(_ backgroundColor:Int, textColor:Int, message:String)
    {
        //    SCLAlertView().showError("ERROR", subTitle: title)
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = NSTextAlignment.center
        label.text = message
        label.font = UIFont(name: "Roboto-Bold", size: 15.0)
        label.adjustsFontSizeToFitWidth = true
        
        if(backgroundColor == 0)
        {
            label.backgroundColor = UIColor.white
        } else if(backgroundColor == 1)
        {
            label.backgroundColor = UIColor.white
        }else if(backgroundColor == 2)
        {
            label.backgroundColor = UIColor.white
        }else if(backgroundColor == 3)
        {
            label.backgroundColor = UIColor.white
        }
        
        if(textColor == 0)
        {
            label.textColor = UIColor.green
        } else if(textColor == 1)
        {
            label.textColor = UIColor.green
        }else if(textColor == 2)
        {
            label.textColor = UIColor.red
        }else if(textColor == 3)
        {
            label.textColor = UIColor.orange
        }
        label.sizeToFit()
        label.numberOfLines = 4
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOffset = CGSize(width: 4, height: 3)
        label.layer.shadowOpacity = 0.3
        label.frame = CGRect(x: 320, y: 64, width: UIScreen.main.bounds.size.width, height: 50)
        appDelegate.window!.addSubview(label)
        label.alpha = 1
        
        var basketTopFrame: CGRect = label.frame;
        basketTopFrame.origin.x = 0;
        
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            label.frame = basketTopFrame
            },  completion: {
                (value: Bool) in
                UIView.animate(withDuration: 2.0, delay: 2.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    label.alpha = 0
                    },  completion: {
                        (value: Bool) in
                        label.removeFromSuperview()
                })
        })
    }
}
