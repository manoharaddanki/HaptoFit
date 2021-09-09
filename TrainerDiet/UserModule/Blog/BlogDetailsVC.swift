//
//  BlogDetailsVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 15/08/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
import SDWebImage

class BlogDetailsVC: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet var headerView: UIView!

    var content = String()
    var imgStr = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)

        wkWebView.navigationDelegate = self
        
        Services.sharedInstance.customLoader(view: self.view, message: "Please wait")
               
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
                   
        let myURL = URL(string: self.imgStr)
        let myRequest = URLRequest(url: myURL!)
        //self.wkWebView.load(myRequest)
        self.wkWebView.loadHTMLString(headerString + self.content, baseURL: nil)

        self.imgView.sd_setImage(with: URL (string: self.imgStr), placeholderImage:UIImage(named:""))
        Services.sharedInstance.dissMissLoader()
              
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true

       
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, attributedString.length))
            
            return attributedString
      } catch {
           return NSAttributedString()
        }
    }
    var htmlToString: String {
       return htmlToAttributedString?.string ?? ""
   }
}
