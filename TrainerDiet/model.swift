//
//  model.swift
//  OnTimeCustomer
//
//  Created by Apple on 19/02/20.
//  Copyright © 2020 Volive Solutions. All rights reserved.
//

import Foundation

class loginModel{
    var phone:String!
    var password:String!
    var otp:String!
    var user_id:String!
    //latest
    var  address:String!
    var  agree_terms:Int!
    var approval_status:Int!
    var auth_level:Int!
    var category:String!
    var created_on:String!
    var device_name:String!
    var device_token:String!
    var dob:String!
    var email:String!
    var first_name:String!
    var gender:String!
    var lang:String!
    var last_name:String!
    var mobile:String!
    var otp_status:String!
    var profile_pic:String!
    var role:String!
    var sub_category:String!
    var updated_on:String!
    var user_status:String!
    var username:String!
    
    init(data : NSDictionary) {
        
        if let id = data["user_id"]{
            self.user_id = id as? String
        }
        if let mobileNo = data["phone"]{
            self.phone = mobileNo as? String
        }
        if let otpStatus = data["otp"]{
            self.otp = otpStatus as? String
        }
        if let password = data["passwd"]{
            self.password = password as? String
        }
        
        if let address = data["address"]{
            self.address = address as? String
        }
        if let agree_terms = data["agree_terms"]{
            self.agree_terms = agree_terms as? Int
        }
        if let approval_status = data["approval_status"]{
            self.approval_status = approval_status as? Int
        }
        if let auth_level = data["auth_level"]{
            self.auth_level = auth_level as? Int
        }
        if let category = data["category"]{
            self.category = category as? String
        }
        if let created_on = data["created_on"]{
            self.created_on = created_on as? String
        }
        if let device_name = data["device_name"]{
            self.device_name = device_name as? String
        }
        if let device_token = data["device_token"]{
            self.device_token = device_token as? String
        }
        if let dob = data["dob"]{
            self.dob = dob as? String
        }
        if let email = data["email"]{
            self.email = email as? String
        }
        if let first_name = data["first_name"]{
            self.first_name = first_name as? String
        }
        if let gender = data["gender"]{
            self.gender = gender as? String
        }
        if let lang = data["lang"]{
            self.lang = lang as? String
        }
        if let last_name = data["last_name"]{
            self.last_name = last_name as? String
        }
        if let mobile = data["mobile"]{
            self.mobile = mobile as? String
        }
        if let otp = data["otp"]{
            self.otp = otp as? String
        }
        if let profile_pic = data["profile_pic"]{
            self.profile_pic = profile_pic as? String
        }
        if let role = data["role"]{
            self.role = role as? String
        }
        if let sub_category = data["sub_category"]{
            self.sub_category = sub_category as? String
        }
        if let user_status = data["user_status"]{
            self.user_status = user_status as? String
        }
        if let username = data["username"]{
            self.username = username as? String
        }
        if let updated_on = data["updated_on"]{
            self.updated_on = updated_on as? String
        }
        
        
        
        
    }
}


class registrationModel{
    var phone:String!
    var password:String!
    var otp:String!
    var user_id:String!
    //latest
    var  address:String!
    var  agree_terms:Int!
    var approval_status:Int!
    var auth_level:Int!
    var category:String!
    var created_on:String!
    var device_name:String!
    var device_token:String!
    var dob:String!
    var email:String!
    var first_name:String!
    var gender:String!
    var lang:String!
    var last_name:String!
    var mobile:String!
    var otp_status:String!
    var profile_pic:String!
    var role:String!
    var sub_category:String!
    var updated_on:String!
    var user_status:String!
    var username:String!
    
    init(data : NSDictionary) {
        
        if let id = data["user_id"]{
            self.user_id = id as? String
        }
        if let mobileNo = data["phone"]{
            self.phone = mobileNo as? String
        }
        if let otpStatus = data["otp"]{
            self.otp = otpStatus as? String
        }
        if let password = data["passwd"]{
            self.password = password as? String
        }
        
        if let address = data["address"]{
            self.address = address as? String
        }
        if let agree_terms = data["agree_terms"]{
            self.agree_terms = agree_terms as? Int
        }
        if let approval_status = data["approval_status"]{
            self.approval_status = approval_status as? Int
        }
        if let auth_level = data["auth_level"]{
            self.auth_level = auth_level as? Int
        }
        if let category = data["category"]{
            self.category = category as? String
        }
        if let created_on = data["created_on"]{
            self.created_on = created_on as? String
        }
        if let device_name = data["device_name"]{
            self.device_name = device_name as? String
        }
        if let device_token = data["device_token"]{
            self.device_token = device_token as? String
        }
        if let dob = data["dob"]{
            self.dob = dob as? String
        }
        if let email = data["email"]{
            self.email = email as? String
        }
        if let first_name = data["first_name"]{
            self.first_name = first_name as? String
        }
        if let gender = data["gender"]{
            self.gender = gender as? String
        }
        if let lang = data["lang"]{
            self.lang = lang as? String
        }
        if let last_name = data["last_name"]{
            self.last_name = last_name as? String
        }
        if let mobile = data["mobile"]{
            self.mobile = mobile as? String
        }
        if let otp = data["otp"]{
            self.otp = otp as? String
        }
        if let profile_pic = data["profile_pic"]{
            self.profile_pic = profile_pic as? String
        }
        if let role = data["role"]{
            self.role = role as? String
        }
        if let sub_category = data["sub_category"]{
            self.sub_category = sub_category as? String
        }
        if let user_status = data["user_status"]{
            self.user_status = user_status as? String
        }
        if let username = data["username"]{
            self.username = username as? String
        }
        if let updated_on = data["updated_on"]{
            self.updated_on = updated_on as? String
        }
        
        
        
        
    }
}

class  BannersResponseModel{
    
    var id: String!
    var image : String!
    
    
    init(data : NSDictionary) {
        
        if let id = data["id"]{
            self.id = id as? String
        }
        if let image = data["image"]{
            self.image = image as? String
        }
    }
}
class ContactUsMOdel{
    var userId:String!
    var name:String!
    var email:String!
    var phone:String!
    var message:String!
    
    init(data : NSDictionary) {
        
        if let id = data["user_id"]{
            self.userId = id as? String
        }
        if let mobileNo = data["phone"]{
            self.phone = mobileNo as? String
        }
        if let email = data[""]{
            self.email = email as? String
        }
    }
}
class  SearchSubClientModel{
    
    var id : String! ,subFirstName : String!,subLastName : String!,subLocation : String!,subGender : Int!, subMobPrimary : Int!, subMobSecondary : Int!, subOccupation : String!,subDateOfBirth : String!,subHeight : Int!,subWeight : Int!,subDietGoal : Int!,subDietDuration : Int!,subDietProfType : Int!,subCuisinePreferrence : Int!,subMedHist : Int!, subFoodChoice : Int!, subFitnessLevel : String!, subSubscriptionPlan : String! , subDetailsStatus : String!, wellnessScore : NSDictionary!, bmrCalc : NSDictionary!, bmrResults : NSArray!, dietRecos : NSArray!, subscriberWorkouts : NSArray!,subDietCategory: Int!,subsGender: Int!
    
    
    init(data : NSDictionary) {
        
        if let id = data["id"]{
            self.id = id as? String
        }
        if let subFirstName = data["subFirstName"]{
            self.subFirstName = subFirstName as? String
        }
        if let subLastName = data["subLastName"]{
            self.subLastName = subLastName as? String
        }
        if let subLocation = data["subLocation"]{
            self.subLocation = subLocation as? String
        }
        if let subGender = data["subGender"]{
            self.subGender = subGender as? Int
        }
        if let subMobPrimary = data["subMobPrimary"]{
            self.subMobPrimary = subMobPrimary as? Int
        }
        if let subMobSecondary = data["subMobSecondary"]{
            self.subMobSecondary = subMobSecondary as? Int
        }
        
        if let subOccupation = data["subOccupation"]{
            self.subOccupation = subOccupation as? String
        }
        if let subDateOfBirth = data["subDateOfBirth"]{
            self.subDateOfBirth = subDateOfBirth as? String
        }
        if let subHeight = data["subHeight"]{
            self.subHeight = subHeight as? Int
        }
        if let subWeight = data["subWeight"]{
            self.subWeight = subWeight as? Int
        }
        if let subDietGoal = data["subDietGoal"]{
            self.subDietGoal = subDietGoal as? Int
        }
        if let subDietDuration = data["subDietDuration"]{
            self.subDietDuration = subDietDuration as? Int
        }
        if let subDietProfType = data["subDietProfType"]{
            self.subDietProfType = subDietProfType as? Int
        }
        
        if let subCuisinePreferrence = data["subCuisinePreferrence"]{
            self.subCuisinePreferrence = subCuisinePreferrence as? Int
        }
        if let subMedHist = data["subMedHist"]{
            self.subMedHist = subMedHist as? Int
        }
        if let subFoodChoice = data["subFoodChoice"]{
            self.subFoodChoice = subFoodChoice as? Int
        }
        if let subFitnessLevel = data["subFitnessLevel"]{
            self.subFitnessLevel = subFitnessLevel as? String
        }
        if let subSubscriptionPlan = data["subSubscriptionPlan"]{
            self.subSubscriptionPlan = subSubscriptionPlan as? String
        }
        if let subDetailsStatus = data["subDetailsStatus"]{
            self.subDetailsStatus = subDetailsStatus as? String
        }
        if let wellnessScore = data["wellnessScore"]{
            self.wellnessScore = wellnessScore as? NSDictionary
        }
        if let bmrCalc = data["bmrCalc"]{
            self.bmrCalc = bmrCalc as? NSDictionary
        }
        if let bmrResults = data["bmrResults"]{
            self.bmrResults = bmrResults as? NSArray
        }
        if let dietRecos = data["dietRecos"]{
            self.dietRecos = dietRecos as? NSArray
        }
        if let subscriberWorkouts = data["subscriberWorkouts"]{
            self.subscriberWorkouts = subscriberWorkouts as? NSArray
        }
        if let subDietCategory = data["subDietCategory"]{
            self.subDietCategory = subDietCategory as? Int
        }
        if let subsGender = data["subsGender"]{
            self.subsGender = subsGender as? Int
        }
    }
}

class SearchAllClientListModel {
    
    var id : Int! ,trainerId : Int!,subscriberFirstName : String!,subscriberLastName : String!,subscriberGender : Int!, subscriberPrimaryMob : Int!, subscriberEmail : String!, subscriberFitnessLevel: String!,subscriberSubscriptionPlan: String!, subscriberProfile : NSDictionary!

    init(data : NSDictionary) {

          if let idStr = data["id"]{
              self.id = idStr as? Int
          }
          if let trainerIdStr = data["trainerId"]{
              self.trainerId = trainerIdStr as? Int
          }
          if let subscriberFirstNameStr = data["subscriberFirstName"]{
              self.subscriberFirstName = subscriberFirstNameStr as? String
          }
          if let subscriberLastNameStr = data["subscriberLastName"]{
              self.subscriberLastName = subscriberLastNameStr as? String
          }
        if let subscriberGenderStr = data["subscriberGender"]{
            self.subscriberGender = subscriberGenderStr as? Int
        }
        if let subscriberPrimaryMobStr = data["subscriberPrimaryMob"]{
            self.subscriberPrimaryMob = subscriberPrimaryMobStr as? Int
        }
        if let subscriberEmailStr = data["subscriberEmail"]{
            self.subscriberEmail = subscriberEmailStr as? String
        }
        if let subscriberFitnessLevelStr = data["subscriberFitnessLevel"]{
            self.subscriberFitnessLevel = subscriberFitnessLevelStr as? String
        }
        if let subscriberSubscriptionPlanStr = data["subscriberSubscriptionPlan"]{
            self.subscriberSubscriptionPlan = subscriberSubscriptionPlanStr as? String
        }
          if let subscriberProfileDict = data["subscriberProfile"]{
              self.subscriberProfile = subscriberProfileDict as? NSDictionary
          }
    }
}


class MemberShipPackagesList {
    
    var id : Int!,gymId:Int! ,trainerId : Int!,subID : Int!,membershipTitle : String!,planPeriod : Int!, gender : Int!, membershipCategory : String!, membershipCost: Int!,discount: Int!, finalPrice : Int!

    init(data : NSDictionary) {

          if let idStr = data["id"]{
              self.id = idStr as? Int
          }
          if let trainerIdStr = data["trainerId"]{
              self.trainerId = trainerIdStr as? Int
          }
        if let gymId = data["gymId"]{
        self.gymId = gymId as? Int
         }
          if let subID = data["subID"]{
              self.subID = subID as? Int
          }
          if let membershipTitle = data["membershipTitle"]{
              self.membershipTitle = membershipTitle as? String
          }
        if let planPeriod = data["planPeriod"]{
            self.planPeriod = planPeriod as? Int
        }
        if let gender = data["gender"]{
            self.gender = gender as? Int
        }
        if let membershipCategory = data["membershipCategory"]{
            self.membershipCategory = membershipCategory as? String
        }
        if let membershipCost = data["membershipCost"]{
            self.membershipCost = membershipCost as? Int
        }
        if let discount = data["discount"]{
            self.discount = discount as? Int
        }
          if let finalPrice = data["finalPrice"]{
              self.finalPrice = finalPrice as? Int
          }
    }
}




