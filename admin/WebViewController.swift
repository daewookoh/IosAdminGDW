//
//  ViewController.swift
//  test
//
//  Created by design on 2015. 9. 17..
//  Copyright (c) 2015년 design. All rights reserved.
//

import UIKit
import WebKit

@available(iOS 8.0, *)
class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler{
    
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myViewForWeb: UIView!

    @IBAction func menuBtnClicked(sender: AnyObject) {
        self.revealViewController().revealToggle(self)
    }
    
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func forwardBtnClicked(sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func reloadBtnClicked(sender: AnyObject) {
        if(CheckInternetConnection.isConnectedToNetwork())
        {
            webView.reload()
        }
        else
        {
            let alert = UIAlertView(title: "인터넷 접속불가", message: "인터넷 연결상태를 확인하세요.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    var datePicker: UIDatePicker!
    var selectedDate: String = ""
    var selTitle:String = ""
    var url:String = ""
    var webViewUrl:String = ""
    var osWebUrl:String = ""
    var selUrl:String = ""
    var selMode:String = ""
    var myUrl:String = ""
    var user:UserInfo = UserInfo()
    var alertController: UIAlertController!
    var webView: WKWebView!
    var contentController = WKUserContentController()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 슬라이딩 메뉴 설정
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        contentController.addScriptMessageHandler(
            self,
            name: "ios"
        )
        
        // wkwebview 설정
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)

        webViewUrl = selUrl
        
        // Default 값
        if (selMode != "webview_page")
        {
            selTitle = "옹달샘일정[모바일]"
            url = "http://www.godowoncenter.com/admingoc/report/m/today.goc"
            
            let encodedUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            
            if let encodedUrl = encodedUrl {
                
                webViewUrl =
                "http://www.godowon.com/m/surl.gdw?url=\(encodedUrl)&gdw_mem_no=\(user.gdw_mem_no)&goc_mem_no=\(user.goc_mem_no)"
                
            }
        }
        
        myTitle.text = selTitle

        if(selMode == "os_web_page")
        {
            osWebUrl = selUrl
            UIApplication.sharedApplication().openURL(NSURL(string: osWebUrl)!)
        }
        
        if let theWebView = webView{
            loadWebViewWithUrl(webViewUrl)
            theWebView.navigationDelegate = self
            //theWebView.UIDelegate = self
            myViewForWeb.addSubview(theWebView)
            
        }



    }
    
    func userContentController(userContentController: WKUserContentController,didReceiveScriptMessage message: WKScriptMessage) {

        if(message.body.isEqualToString("[ChangeDate]")) {
            createDatePickerViewWithAlertController()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadWebViewWithUrl(urlInfo: String) {
        let url = NSURL(string: urlInfo)
        let request = NSURLRequest(URL: url!)

        if(CheckInternetConnection.isConnectedToNetwork())
        {
            webView.loadRequest(request)
        }
        else
        {
            let alert = UIAlertView(title: "인터넷 접속불가", message: "인터넷 연결상태를 확인하세요.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }

    func webView(webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation){
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView,
        didFinishNavigation navigation: WKNavigation){
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
  

    // MARK: WKUIDelegate methods
    
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (() -> Void)) {

        //print("webView:\(webView) runJavaScriptAlertPanelWithMessage:\(message) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
        
        let alertController = UIAlertController(title: frame.request.URL?.host, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            completionHandler()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)


    }
    
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: ((Bool) -> Void)) {
        //print("webView:\(webView) runJavaScriptConfirmPanelWithMessage:\(message) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
        
        let alertController = UIAlertController(title: frame.request.URL?.host, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            completionHandler(false)
        }))
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            completionHandler(true)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func createDatePickerViewWithAlertController()
    {
        
        let viewDatePicker: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        viewDatePicker.backgroundColor = UIColor.clearColor()
        
        
        datePicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: nil, forControlEvents: UIControlEvents.ValueChanged)
        
        viewDatePicker.addSubview(datePicker)
        
        
        if(UIDevice.currentDevice().systemVersion >= "8.0")
        {
            
            let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            alertController.view.addSubview(viewDatePicker)
            
            let cancelAction = UIAlertAction(title: "취소", style: .Cancel)
                { (action) in
                    // ...
            }
            
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "선택", style: .Default)
                { (action) in
                    
                    self.dateSelected()
            }
            
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true)
                {
                    // ...
            }
            
        }
        else
        {
            let actionSheet = UIActionSheet()
            actionSheet.addButtonWithTitle("iOS 버젼을 업데이트 해주세요")
            actionSheet.showInView(self.view)
        }
    }
    
    func dateSelected()
    {
        selectedDate =  dateformatterDate(self.datePicker.date) as String
        myUrl = "http://www.godowoncenter.com/admingoc/report/m/today.goc?Ymd=" + selectedDate
        loadWebViewWithUrl(myUrl)
    }
    
    func dateformatterDate(date: NSDate) -> NSString
    {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    
    // Now Implement UIActionSheet Delegate Method just for support for iOS 7 not for iOS 8
    // MARK: - UIActionSheet Delegate Implementation ::
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex
        {
        case 0:
            print("Done")
            dateSelected()
            break;
        case 1:
            print("Cancel")
            break;
        default:
            print("Default")
            break;
        }
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}


