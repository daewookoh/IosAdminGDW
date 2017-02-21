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

    @IBAction func menuBtnClicked(_ sender: AnyObject) {
        self.revealViewController().revealToggle(self)
    }
    
    
    @IBAction func backBtnClicked(_ sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func forwardBtnClicked(_ sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func reloadBtnClicked(_ sender: AnyObject) {
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
        
        contentController.add(
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
            
            let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            
            if let encodedUrl = encodedUrl {
                
                webViewUrl =
                "http://www.godowon.com/m/surl.gdw?url=\(encodedUrl)&gdw_mem_no=\(user.gdw_mem_no)&goc_mem_no=\(user.goc_mem_no)"
                
            }
        }
        
        myTitle.text = selTitle

        if(selMode == "os_web_page")
        {
            osWebUrl = selUrl
            UIApplication.shared.openURL(URL(string: osWebUrl)!)
        }
        
        if let theWebView = webView{
            loadWebViewWithUrl(webViewUrl)
            theWebView.navigationDelegate = self
            //theWebView.UIDelegate = self
            myViewForWeb.addSubview(theWebView)
            
        }



    }
    
    func userContentController(_ userContentController: WKUserContentController,didReceive message: WKScriptMessage) {

        if((message.body as AnyObject).isEqual(to: "[ChangeDate]")) {
            createDatePickerViewWithAlertController()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadWebViewWithUrl(_ urlInfo: String) {
        let url = URL(string: urlInfo)
        let request = URLRequest(url: url!)

        if(CheckInternetConnection.isConnectedToNetwork())
        {
            webView.load(request)
        }
        else
        {
            let alert = UIAlertView(title: "인터넷 접속불가", message: "인터넷 연결상태를 확인하세요.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }

    func webView(_ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation){
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView,
        didFinish navigation: WKNavigation){
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  

    // MARK: WKUIDelegate methods
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (@escaping () -> Void)) {

        //print("webView:\(webView) runJavaScriptAlertPanelWithMessage:\(message) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
        
        let alertController = UIAlertController(title: frame.request.url?.host, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler()
        }))
        self.present(alertController, animated: true, completion: nil)


    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (@escaping (Bool) -> Void)) {
        //print("webView:\(webView) runJavaScriptConfirmPanelWithMessage:\(message) initiatedByFrame:\(frame) completionHandler:\(completionHandler)")
        
        let alertController = UIAlertController(title: frame.request.url?.host, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            completionHandler(false)
        }))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler(true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func createDatePickerViewWithAlertController()
    {
        
        let viewDatePicker: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        viewDatePicker.backgroundColor = UIColor.clear
        
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: nil, for: UIControlEvents.valueChanged)
        
        viewDatePicker.addSubview(datePicker)
        
        
        if(UIDevice.current.systemVersion >= "8.0")
        {
            
            let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            alertController.view.addSubview(viewDatePicker)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                { (action) in
                    // ...
            }
            
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "선택", style: .default)
                { (action) in
                    
                    self.dateSelected()
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true)
                {
                    // ...
            }
            
        }
        else
        {
            let actionSheet = UIActionSheet()
            actionSheet.addButton(withTitle: "iOS 버젼을 업데이트 해주세요")
            actionSheet.show(in: self.view)
        }
    }
    
    func dateSelected()
    {
        selectedDate =  dateformatterDate(self.datePicker.date) as String
        myUrl = "http://www.godowoncenter.com/admingoc/report/m/today.goc?Ymd=" + selectedDate
        loadWebViewWithUrl(myUrl)
    }
    
    func dateformatterDate(_ date: Date) -> NSString
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date) as NSString
    }
    
    
    // Now Implement UIActionSheet Delegate Method just for support for iOS 7 not for iOS 8
    // MARK: - UIActionSheet Delegate Implementation ::
    func actionSheet(_ actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int)
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
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}


