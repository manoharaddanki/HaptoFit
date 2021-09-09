//
//  Constants.swift
//  Balloonzy
//
//  Created by rize on 20/01/16.
//  Copyright © 2016 rize. All rights reserved.
//

import Foundation
import UIKit



//MARK:- Device
let DEVICE_TYPE_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
let DEVICE_TYPE_IPHONE = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

//MARK:- Service
let APP_RED_COLOR = UIColor.init(named: "175480") //C20000
let USER_DEFAULTS = UserDefaults.standard
let USER_NAME_KEY = "userName"
let PASSWORD_KEY = "password"



let APIKEY = "9876543"
//"1514209135"
let DEVICE_TOKEN = "deviceToken"
let UserDefault = UserDefaults.standard
//let DEVICETOKEN = UserDefaults.standard.object(forKey: "deviceToken")
let DEVICETYPE = "iOS"
let USER_ID = UserDefaults.standard.object(forKey: "user_id")
let CUSTOMUR_ID = UserDefaults.standard.object(forKey: "customer_id")
let CATEGORY_ID = UserDefaults.standard.object(forKey: "category_id")
let LANGUAGE = "en"
let ENGLISH_LANGUAGE = 1
let ARABIC_LANGUAGE = 2
//MARK:- Fonts
let FONT_SIZE_MEDIUM = UIFont(name: "Gotham-Medium", size: 16)
let FONT_SIZE_BOOK = UIFont(name: "Gotham-Book", size: 16)


let heigthArr = ["100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200"]

let WeigthArr = ["40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150"]
var navigation_flow = String()

//MARK:- NOT FOUND
enum NotFoundEnum: String {
    case NoMessages = "No Messages Found."
    case NoFriends = "No Friends Found."
    case NoRequest = "No Friend Requests Sent."
    case NoReceived = "No Friend Requests Received."
    case NoRecentlyPlayed = "No Topics Played Recently."
    case NoTopic = "Sorry, this topic is currently unavailable. Stay tuned for new topics soon!"//"Sorry! Entered topic is currently not available. It will be available shortly.Stay tuned."
    case NoOwnpeacePlayer = "No Players Data."
    case NoLevelsData = "No Levels Data."
    case NoFreePlayData = "No Free Play Data."
    case NoChallengePlayer = "No Challenges Data."
    case NoChallengesReveived = "No Challenges Received."
    case NoChallengesSent = "No Challenges Sent."
}

extension UITableView {
    
    func setEmptyMessage(_ message: String, txtColor : UIColor) {
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = txtColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: DEVICE_TYPE_IPAD ? 20 : 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

//ImageView Tint Color
@IBDesignable class TintedImageView: UIImageView {
    
    override func prepareForInterfaceBuilder() {
        self.configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configure()
    }
    
    @IBInspectable override var tintColor: UIColor! {
        didSet {
            self.configure()
        }
    }
    
    private func configure() {
        self.image = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    }
}

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}



@IBDesignable extension UILabel {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String, txtColor : UIColor) {
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = txtColor
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: DEVICE_TYPE_IPAD ? 22 : 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}



extension UIView {
    
    func fadeIn() {
        
        self.alpha = 0.0
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() -> Bool {
        
        var complete = false
        
        self.alpha = 1.0
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: { (Bool) in
            
            complete = true
        })
        return complete
    }
}

func getCountryCallingCode(countryRegionCode:String)->String {
    
    let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
    let countryDialingCode = prefixCodes[countryRegionCode]
    return countryDialingCode!
}

func getShortNames(name: String) -> String {
    
    var shortNameStr = String()
    let wordStr = name.split(separator: " ")
    
    if wordStr.count >= 2 {
             
        shortNameStr = (String(wordStr[0].first!)+String(wordStr[1].first!)).uppercased()
             
    }else{
        
    }
    
    return shortNameStr
}


//MARK:- Checking Optionals

func status_Check(dict : NSDictionary) -> Bool {
    
    if let status = dict.value(forKey: "status") as? String {
        
        return status == "success" ? true : false;
        
    } else {
        
        return false
    }
}

func bool_CheckOptional(dict : NSDictionary, param_Name : String) -> Bool {
    
    if let wrapped_value = dict.value(forKey: param_Name) as? Bool {
        
        return wrapped_value
        
    } else {
        
        return false
    }
}

func int_CheckOptional(dict : NSDictionary, param_Name : String) -> Int {
    
    if let wrapped_value = dict.value(forKey: param_Name) as? Int {
        
        return wrapped_value
        
    } else {
        
        return 0
    }
}

func float_CheckOptional(dict : NSDictionary, param_Name : String) -> Float {
    
    if let wrapped_value = dict.value(forKey: param_Name) as? Float {
        
        return wrapped_value
        
    } else {
        
        return 0.0
    }
}

func double_CheckOptional(dict : NSDictionary, param_Name : String) -> Double {
    
    if let wrapped_value = dict.value(forKey: param_Name) as? Double {
        
        return wrapped_value
        
    } else {
        
        return 0.0
    }
}

func string_CheckOptional(dict : NSDictionary, param_Name : String) -> String {
    
    if let wrapped_value = dict.value(forKey: param_Name) as? String {
        
        return wrapped_value
        
    } else {
        
        return ""
    }
}

func getstringVal(dict : NSDictionary, param_Name : String) -> String {
    
    if let wrapped_value = dict.value(forKey: param_Name) as? Double {
        
        return "\(wrapped_value)"
    }
    else if let wrapped_value = dict.value(forKey: param_Name) as? Int {
        
        return "\(wrapped_value)"
    }
    else if let wrapped_value = dict.value(forKey: param_Name) as? String {
            
        return wrapped_value
    }
    else {
        
        return ""
    }
}

func dict_CheckOptional(dict : Any, param_Name : String) -> NSDictionary {
    
    if let wrapped_value = (dict as AnyObject).value(forKey: param_Name) as? NSDictionary {
        
        return wrapped_value
        
    } else {
        
        return [:]
    }
}

func Array_CheckOptional(dict : NSDictionary, param_Name : String) -> NSArray {
    
    if let wrapped_value = dict.value(forKey: param_Name) as? NSArray {
        
        return wrapped_value
        
    } else {
        
        return []
    }
}

func dict_responce(dict : NSDictionary?) -> NSDictionary {
    
    if let wrapped_value = dict {
        
        return wrapped_value
        
    } else {
        
        return [:]
    }
}

func get_UserID() -> String {
    
    if let uid = USER_DEFAULTS.value(forKey: "uid") as? String {
        
        return uid
        
    } else {
        
        return ""
    }
}

func get_Auth_Token() -> String {
    
    if let auth_token = USER_DEFAULTS.value(forKey: "auth_token") as? String {
        
        return auth_token
        
    } else {
        
        return ""
    }
}

// MARK: - Dates Handling

func gf_GetFormattedDate(dateStr : String, dateFormatStr: String) -> String {
    
    let dateFormatter2 =  DateFormatter.init()
    dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let istDate = dateFormatter2.date(from: dateStr) ?? Date()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormatStr
    return dateFormatter.string(from: istDate)
}
extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
