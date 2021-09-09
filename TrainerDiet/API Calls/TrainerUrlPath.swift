//
//  TrainerUrlPath.swift
//  TrainerDiet
//
//  Created by Developer Dev on 13/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//


import Foundation

enum Server {
    
    case local
    case dev
    case live
}

class TrinerUrlPath {
    
    let serverType = Server.local
    
    //1
    class var sharedInstance: TrinerUrlPath {
        
        //2
        struct singleton {
            
            //3
            static let instance = TrinerUrlPath()
        }
        
        //4
        return singleton.instance
    }
    
    /// Description
    /// - Parameter section: section description
    func getUrlPath(_ section:String) -> String {
        
        var publicUrlPath = ""
        
        if serverType == .local {
            
            publicUrlPath = "https://beapis.dieatto.com:8090/"
            
        } else  if serverType == .dev {
            
            publicUrlPath = ""
            
        } else {
            
            
            publicUrlPath = ""
        }
        
        let pathToReturn = publicUrlPath + section
                return pathToReturn
    }
    
//    func getMatchesUrlPath(_ section:String) -> String {
//        
//        var publicUrlPath = ""
//        
//        if serverType == .local {
//            
//            publicUrlPath = "http://192.168.1.4:7993/"
//            
//        } else  if serverType == .dev {
//
//            publicUrlPath = "http://52.52.87.215:7993/"
//            
//        } else {
//            
//            publicUrlPath = "https://movies.quizpursuit.com/rc4/"
//        }
//        
//        let pathToReturn = publicUrlPath + section
//        
//        return pathToReturn
//    }
}
