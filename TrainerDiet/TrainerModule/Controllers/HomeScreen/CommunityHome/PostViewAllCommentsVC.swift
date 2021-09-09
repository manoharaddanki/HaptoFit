//
//  PostViewAllCommentsVC.swift
//  TrainerDiet
//
//  Created by Developer Dev on 19/06/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import UIKit

class PostViewAllCommentsVC: UIViewController {
    
    @IBOutlet weak var allCommentsTable : UITableView!
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var name_Lbl : UILabel!

    var commentsListArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.allCommentsTable.reloadData()

//        if let trainerName = UserDefaults.standard.object(forKey: "firstName") as? String {
//
//            self.name_Lbl.text = "Hi, \(trainerName)"
//            
//        }else{
//            
//            self.name_Lbl.text = "Hi"
//
//        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
           
           if let navController = self.navigationController {
               
               navController.popViewController(animated: true)
           }
           
       }

}
extension PostViewAllCommentsVC:UITableViewDataSource,UITableViewDelegate{

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.commentsListArray.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "ViewAllCommentsTVCell", for: indexPath) as? ViewAllCommentsTVCell {
        
        
        if let tempDict = commentsListArray[indexPath.row] as? NSDictionary {
            
            cell.setCellData(resp_Dict: tempDict)
                
        }
        
        return cell
        
    }else{
        
        return UITableViewCell()
    }
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 90
    
}
}
