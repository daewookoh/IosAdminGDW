//
//  ViewController.swift
//  test
//
//  Created by design on 2015. 9. 17..
//  Copyright (c) 2015년 design. All rights reserved.
//

import UIKit
import WebKit

class test: UIViewController {

    
    var myWebView:WKWebView!
    var selTitle:String = ""
    var myUrl:String = ""
    var user:UserInfo = UserInfo()
    
    override func loadView() {
        super.loadView()
        myWebView = WKWebView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pref = WKPreferences()
        pref.javaScriptEnabled = true;
        
        let conf = WKWebViewConfiguration()
        conf.preferences = pref
        
        myWebView = WKWebView(frame: view.bounds, configuration: conf)
        
        myUrl = generateMyUrl(user.gdw_mem_no, goc_mem_no: user.goc_mem_no)
        
        if(CheckInternetConnection.isConnectedToNetwork())
        {
            loadWebViewWithUrl(myUrl)
        }
        else
        {
            let alert = UIAlertView(title: "인터넷 접속불가", message: "인터넷 연결상태를 확인하세요.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadWebViewWithUrl(urlInfo: String) {
        let url = NSURL(string: urlInfo)
        let request = NSURLRequest(URL: url!)
        
        myWebView.loadRequest(request)
    }
    
    
    func generateMyUrl(gdw_mem_no: Int, goc_mem_no: Int) -> String{
        
        var title:String = selTitle
        var url:String = ""
        var finalUrl:String = ""
        
        switch title {
        case "옹달샘일정" :
            url = "http://www.godowoncenter.com/admingoc/report/m/today.goc"
            
        case "아침지기[모바일]" :
            url = "http://www.godowon.com/m/admingdw/index.gdw"
            
        case "아침지기[PC]" :
            url = "http://www.godowon.com/admingdw/index.gdw"
            
        case "스케쥴" :
            url = "http://www.godowon.com/board/gdwboard.gdw?id=admin_Schedule"
            
        case "기타 게시판" :
            url = "http://www.godowon.com/m/admingdw/main_board_list.gdw"
            
        case "내일자 점검" :
            url = "http://www.godowon.com/m/admingdw/check_tomorrow_letter.gdw"
            
        case "통계" :
            url = "http://www.godowon.com/m/admingdw/main_stat.gdw"
            
        case "아침편지 홈" :
            url = "http://www.godowon.com"
            
        case "옹달샘 홈" :
            url = "http://www.godowoncenter.com"
            
        default :
            title = "옹달샘일정"
            url = "http://www.godowoncenter.com/admingoc/report/m/today.goc"
            
        }
        
        //myTitle.text = title
        
        let encodedUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        if let encodedUrl = encodedUrl {
            
            finalUrl =
            "http://www.godowon.com/m/surl.gdw?url=\(encodedUrl)&gdw_mem_no=\(gdw_mem_no)&goc_mem_no=\(goc_mem_no)"
            
        }
        
        return finalUrl
        
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}


