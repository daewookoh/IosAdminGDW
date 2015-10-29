//
//  BackTableViewController.swift
//  test
//
//  Created by design on 2015. 9. 17..
//  Copyright (c) 2015년 design. All rights reserved.
//

import Foundation

@available(iOS 8.0, *)
class TableViewMenuController: UITableViewController {
    @IBOutlet weak var myName: UILabel!
    
    var TableArray = [String]()
    var myWebView = WebViewController()
    var user:UserInfo = UserInfo()
    
    override func viewDidLoad() {
        
        myName.text = user.name
        
        TableArray = [
            "옹달샘일정[모바일]",
            "옹달샘일정[PC]",
            "아침지기 이메일",
            "아침지기[모바일]",
            "아침지기[PC]",
            "스케쥴",
            "기타 게시판",
            "내일자 점검",
            "통계",
            "아침편지 홈",
            "옹달샘 홈",
            "꽃마 홈"
        ]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        cell.textLabel?.textColor = myWebView.uicolorFromHex(0x54a5e6)
        cell.textLabel?.font = UIFont(name: "systemFont", size: 9)
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let DestVC = segue.destinationViewController as! WebViewController
        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        let selTitle = TableArray[indexPath.row]
        
        DestVC.selTitle = selTitle
    }


}
    