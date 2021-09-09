//
//  AppDelegate.swift
//  TrainerDiet
//
//  Created by RadhaKrishna on 17/05/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseAnalytics
import Firebase
import FirebaseCore

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
        
    var userPersonalInfoStatus = UserDefaults.standard.object(forKey: "personalInfo") as? Bool ?? false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        //        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        FirebaseApp.configure()
        
        if #available(iOS 13.0, *) {
                   window!.overrideUserInterfaceStyle = .light
               } else {
                   // Fallback on earlier versions
               }
        let trainerMobile = UserDefaults.standard.object(forKey: "mobile") as? String
        
        let trainerEmailId = UserDefaults.standard.object(forKey: "emailId") as? String
        
        let subEmailId = UserDefaults.standard.object(forKey: "subEmailId") as? String
        let subMobile = UserDefaults.standard.object(forKey: "subMobile") as? Int
        
        //let trainerId = UserDefaults.standard.object(forKey: "trainerId") as? String
        
        let userLoginStatus = UserDefaults.standard.object(forKey: "userLogin") as? Bool
        
        let trainerLoginStatus = UserDefaults.standard.object(forKey: "trainerLogin") as? Bool
                
        if trainerLoginStatus == true {
            
            if trainerMobile?.count == 0 || trainerMobile == nil  {
                
                let storyBoard = UIStoryboard(name:"Main", bundle:nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
                self.window?.rootViewController = controller;
                
            }
                
            else
            {
                let storyBoard = UIStoryboard(name:"Main", bundle:nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                self.window?.rootViewController = controller;
                
            }
            
        }else if userLoginStatus == true {
                       
                if userPersonalInfoStatus == false {

                    let storyBoard = UIStoryboard(name:"Main", bundle:nil)
                    let controller = storyBoard.instantiateViewController(withIdentifier: "PersonalInfoVC")
                    let rootViewController = self.window!.rootViewController as! UINavigationController
                    rootViewController.pushViewController(controller, animated: true)

                }
                else{
                    
                       if subEmailId?.count == 0 || subMobile == 0  || subMobile == nil || subEmailId == nil {
                           
                           let storyBoard = UIStoryboard(name:"Main", bundle:nil)
                           let controller = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
                           self.window?.rootViewController = controller;
                           
                       }
                           
                       else
                       {
                           let storyBoard = UIStoryboard(name:"Main", bundle:nil)
                           let controller = storyBoard.instantiateViewController(withIdentifier: "UserMainTabVC") as! UserMainTabVC
                           self.window?.rootViewController = controller;
                           
                       }
            }
            
        }else{
            
           

        }
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

