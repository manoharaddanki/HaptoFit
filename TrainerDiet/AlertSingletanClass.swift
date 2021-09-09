//
//  AlertSingletanClass.swift
//  Quiz
//
//  Created by M Venkat  Rao on 10/30/17.
//  Copyright © 2017 Rize. All rights reserved.
//

import UIKit

class AlertSingletanClass: NSObject {
    
    //1
    class var sharedInstance: AlertSingletanClass {
        //2
        struct Singleton {
            //3
            static let instance = AlertSingletanClass()
        }
        //4
        return Singleton.instance
    }
    
    // validation Alerts
    func showAlertView(title alerTitle:String ,message alertMessage:String, preferredStyle style:UIAlertController.Style, okLabel: String, cancelLabel: String, targetViewController: UIViewController,okHandler: ((UIAlertAction?) -> Void)!, cancelHandler: ((UIAlertAction?) -> Void)!){
        
        let alertController = UIAlertController(title: alerTitle, message: alertMessage, preferredStyle: style)
        let cancelAction = UIAlertAction(title: cancelLabel, style: .default,handler: cancelHandler)
        let okAction = UIAlertAction(title: okLabel, style: .default, handler: okHandler)
        
        
        // Add Actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present Alert Controller
        targetViewController.present(alertController, animated: true, completion: nil)
        
    }
    
    func validationAlert(title alerTitle:String ,message alertMessage:String, preferredStyle style:UIAlertController.Style, okLabel: String,  targetViewController: UIViewController,okHandler: ((UIAlertAction?) -> Void)!)
    {
        
        let alertController = UIAlertController(title: alerTitle, message: alertMessage, preferredStyle: style)
        let okAction = UIAlertAction(title: okLabel, style: .default, handler: okHandler)
        
        // Add Actions
        alertController.addAction(okAction)
        
        // Present Alert Controller
        targetViewController.present(alertController, animated: true, completion: nil)
        
    }
    func validationAlertView(title alerTitle:String ,message alertMessage:String, preferredStyle style:UIAlertController.Style, okLabel: String,okHandler: ((UIAlertAction?) -> Void)!)
    {
        
        let alertController = UIAlertController(title: alerTitle, message: alertMessage, preferredStyle: style)
        let okAction = UIAlertAction(title: okLabel, style: .default, handler: okHandler)
        
        // Add Actions
        alertController.addAction(okAction)
          let window = UIWindow(frame: UIScreen.main.bounds)
        // Present Alert Controller
       //UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        window.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    func showLocationEnableAlert(targetViewController: UIViewController) {
        
        let alertController = UIAlertController(title: "Location Services Disabled",
                                                message: "This app requires access to your location for showing your location specific Movies, Theatres, etc.",preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Go to Settings", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
            UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (alert: UIAlertAction!) in
            
        }))
        //alertController.addAction(OKAction)
        OperationQueue.main.addOperation {
            targetViewController.present(alertController, animated: true,
                         completion:nil)
        }
    }
}
