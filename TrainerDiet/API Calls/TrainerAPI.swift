//
//  TrainerAPI.swift
//  TrainerDiet
//
//  Created by Developer Dev on 13/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//


import Foundation
import Alamofire

typealias ServiceResponse = (NSDictionary?, NSError?) -> Void
typealias SuccessResponse = (NSDictionary?, NSInteger?) -> Void
typealias FailuerResponse = (NSString?, NSInteger?, Error?) -> Void
typealias FailureReasonse = (NSString?)-> Void

class TrinerAPI: NSObject {
   
    //1
    class var sharedInstance : TrinerAPI {
        
        //2
        struct Singleton {
            
            //3
            static let instance = TrinerAPI()
        }
        //4
        return Singleton.instance
    }
    
    //MARK: - Get Service
    func TrinerService_get( paramsDict : NSDictionary, urlPath : String, onCompletion: @escaping ServiceResponse) -> Void {
        
        print("Get :", urlPath)
        
        let startDate = Date()
        
        let params : [String : AnyObject] = paramsDict as! [String : AnyObject]
        
        Alamofire.request(urlPath, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            // .responseString {(response)  in responseJSON
             //print(response)
            
            //print("Responce Time : \(urlPath) Difference = \(Date().timeIntervalSince(startDate)) Duration = \(response.timeline.totalDuration)")

            switch response.result {
                
            case .success(let JSON):
                onCompletion(JSON as? NSDictionary, nil)
                print("registerUserStepOne========: \(JSON)")

            case .failure(let error):
                print(error)
                onCompletion(nil, error as NSError?)
            }
        }
    }
    
    //MARK: - Post Service
    func TrinerService_post( paramsDict : NSDictionary, urlPath : String, onCompletion: @escaping ServiceResponse) -> Void {
        
        print("Post : ", urlPath)
        
        print("\nParams : ", paramsDict)
        
        let startDate = Date()
        
        let params : [String : AnyObject] = paramsDict as! [String : AnyObject]
                    
            Alamofire.request(urlPath, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
                // .responseString {(response)  in responseJSON
                //print(response)
                
//                print("Responce Time : \(urlPath) Difference = \(Date().timeIntervalSince(startDate)) Duration = \(response.timeline.totalDuration)")

                switch response.result {
                case .success(let JSON):
                    print("registerUserStepOne========: \(JSON)")
                    onCompletion(JSON as? NSDictionary, nil)
                    
                case .failure(let error):
                    print(error)
                    onCompletion(nil, error as NSError?)
                    
                }
                
            }
    }
    
    //MARK: - Post With Header Service
    func TrinerService_post_with_header( paramsDict : NSDictionary, urlPath : String, onCompletion: @escaping ServiceResponse) -> Void {
        
        print("PostWithHeader : ", urlPath)
        
        print("\nParams : ", paramsDict)
        
        let startDate = Date()
        
        let params : [String : AnyObject] = paramsDict as! [String : AnyObject]
        
        Alamofire.request(urlPath, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json; charset=utf-8", "accept": "application/json"]).responseJSON{ (response) in
            // .responseString {(response)  in responseJSON
            //print(response)
            
//            print("Responce Time : \(urlPath) Difference = \(Date().timeIntervalSince(startDate)) Duration = \(response.timeline.totalDuration)")

            switch response.result {
            case .success(let JSON):
               print("registerUserStepOne========: \(JSON)")
                onCompletion(JSON as? NSDictionary, nil)
                
            case .failure(let error):
                print(error)
                onCompletion(nil, error as NSError?)
                
            }
            
        }
    }
    
    //MARK: - Put Service
    func TrainerService_put( paramsDict : NSDictionary, urlPath : String, onCompletion: @escaping ServiceResponse) -> Void {
        
        print("Put : ", urlPath)
        
        print("\nParams : ", paramsDict)
        
        let startDate = Date()
        
        let params : [String : AnyObject] = paramsDict as! [String : AnyObject]
        
        Alamofire.request(urlPath, method: .put, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON{ (response) in
            // .responseString {(response)  in responseJSON
            //print(response)
            
//            print("Responce Time : \(urlPath) Difference = \(Date().timeIntervalSince(startDate)) Duration = \(response.timeline.totalDuration)")

            switch response.result {
            case .success(let JSON):
                 print("response from API========: \(JSON)")
                onCompletion(JSON as? NSDictionary, nil)
                
            case .failure(let error):
                print(error)
                onCompletion(nil, error as NSError?)
            }
        }
    }
    
    //MARK: - Put With Header Service
    func TrainerService_put_with_header( paramsDict : NSDictionary, urlPath : String, onCompletion: @escaping ServiceResponse) -> Void {
        
        print("Put WithHeader : ", urlPath)
        
        print("\nParams : ", paramsDict)
        
        let startDate = Date()
        
        let params : [String : AnyObject] = paramsDict as! [String : AnyObject]
        
        Alamofire.request(urlPath, method: .put, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json; charset=utf-8", "accept": "application/json"]).responseJSON{ (response) in
            // .responseString {(response)  in responseJSON
            //print(response)
            
//            print("Responce Time : \(urlPath) Difference = \(Date().timeIntervalSince(startDate)) Duration = \(response.timeline.totalDuration)")

            switch response.result {
            case .success(let JSON):
               print("response form API========: \(JSON)")
                onCompletion(JSON as? NSDictionary, nil)
                
            case .failure(let error):
                print(error)
                onCompletion(nil, error as NSError?)
                
            }
            
        }
    }
    
}
