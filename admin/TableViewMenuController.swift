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
    var url:String = ""
    var encodedUrl:String = ""
    var selUrl:String = ""
    var selMode:String = ""
    
    override func viewDidLoad() {
        
        let name = UserDefault.load(key:"name")

        
        myName.text = name
        
        TableArray = [
            "옹달샘일정[모바일]",
            "아침지기[모바일]",
            "아침지기[PC]",
            "내일자 점검",
            "통계",
            "스케쥴",
            "강연요청",
            "옹달샘일정[PC]",
            "요청사항&버그신고",
            "아침지기 이메일",
            "기타 게시판",
            //"아침편지 홈",
            //"옹달샘 홈",
            //"꽃마 홈"
        ]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        cell.textLabel?.textColor = myWebView.uicolorFromHex(0x54a5e6)
        cell.textLabel?.font = UIFont(name: "systemFont", size: 9)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let DestVC = segue.destination as! WebViewController
        let indexPath : IndexPath = self.tableView.indexPathForSelectedRow!
        let selTitle = TableArray[indexPath.row]

        
        switch selTitle {
        case "옹달샘일정[모바일]" :
            url = "http://www.godowoncenter.com/admingoc/report/m/today.goc"
            selMode = "webview_page"
            
        case "옹달샘일정[PC]" :
            url = "http://www.godowoncenter.com/admingoc/program/program_calendar.goc"
            selMode = "webview_page"
            
        case "요청사항&버그신고" :
            url = "http://www.godowon.com/m/admingdw/board_write.gdw?b_code=adminrequest"
            selMode = "os_web_page"
            
        case "아침지기 이메일" :
            url = "http://www.godowon.com/admingdw/index.gdw?redirect=mail"
            selMode = "os_web_page"
            
        case "아침지기[모바일]" :
            url = "http://www.godowon.com/m/admingdw/index.gdw"
            selMode = "os_web_page"
            
        case "아침지기[PC]" :
            url = "http://www.godowon.com/admingdw/index.gdw"
            selMode = "os_web_page"
            
        case "스케쥴" :
            url = "http://www.godowon.com/board/gdwboard.gdw?id=admin_Schedule"
            selMode = "os_web_page"
            
        case "강연요청" :
            url = "http://www.godowon.com/m/admingdw/main_article_list.gdw?b_code=adminlequestlecture"
            selMode = "os_web_page"
            
        case "기타 게시판" :
            url = "http://www.godowon.com/m/admingdw/main_board_list.gdw"
            selMode = "os_web_page"
            
        case "내일자 점검" :
            url = "http://www.godowon.com/m/admingdw/check_tomorrow_letter.gdw"
            selMode = "webview_page"
            
        case "통계" :
            url = "http://www.godowon.com/m/admingdw/main_stat.gdw"
            selMode = "os_web_page"
            
        case "아침편지 홈" :
            url = "http://www.godowon.com"
            selMode = "webview_page"
            
        case "옹달샘 홈" :
            url = "http://www.godowoncenter.com"
            selMode = "webview_page"
            
        case "꽃마 홈" :
            url = "http://www.cconma.com"
            selMode = "webview_page"
            
        default :
            title = "옹달샘일정[모바일]"
            url = "http://www.godowoncenter.com/admingoc/report/m/today.goc"
            selMode = "webview_page"
            
        }
        
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        
        let gdw_mem_no = UserDefault.load(key:"gdw_mem_no")
        let goc_mem_no = UserDefault.load(key:"goc_mem_no")
        if let encodedUrl = encodedUrl {
            
            selUrl =
            "http://www.godowon.com/m/surl.gdw?url=\(encodedUrl)&gdw_mem_no=\(gdw_mem_no)&goc_mem_no=\(goc_mem_no)"
            
        }
        
        DestVC.selTitle = selTitle
        DestVC.selUrl = selUrl
        DestVC.selMode = selMode
    }


}
    
