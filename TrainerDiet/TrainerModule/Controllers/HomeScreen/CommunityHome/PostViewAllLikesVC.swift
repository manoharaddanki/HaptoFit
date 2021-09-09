//
//  PostViewAllLikesVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 19/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class PostViewAllLikesVC: UIViewController {
    
    @IBOutlet weak var allLikesTable : UITableView!
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var name_Lbl : UILabel!

    var likesListArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

//        headerView.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)
//        name_Lbl.addShadow(offset: CGSize(width: 0, height: 1), color: UIColor.lightGray, radius: 2.0, opacity: 1.0, cornerRadius: 2.0)


        self.allLikesTable.reloadData()
//        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
//
//                  self.name_Lbl.text = "Hi, \(trainerName)"
//                  
//              }else{
//                  
//                  self.name_Lbl.text = "Hi"
//
//              }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
           
           if let navController = self.navigationController {
               
               navController.popViewController(animated: true)
           }
           
       }

}
extension PostViewAllLikesVC:UITableViewDataSource,UITableViewDelegate{

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.likesListArray.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllLikeTVCell", for: indexPath) as? ViewAllLikeTVCell {
        
        cell.selectionStyle = .none
        if let tempDict = likesListArray[indexPath.row] as? NSDictionary {
            
            cell.setCellData(resp_Dict: tempDict)
                
        }
        return cell
        
    }else{
        
        return UITableViewCell()
    }
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 60
    
}
}

