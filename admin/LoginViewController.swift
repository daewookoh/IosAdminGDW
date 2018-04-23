//
//  LoginViewController.swift
//  admin-WKWebview
//
//  Created by godowondev on 2018. 4. 20..
//  Copyright © 2018년 design. All rights reserved.
//

import Foundation

class LoginViewController: UIViewController{

    @IBOutlet weak var MyMessage: UILabel!
    @IBOutlet weak var MyName: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
    
    //override func performSegue(withIdentifier identifier: String, sender: Any?) {
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyMessage.text="이름 입력후 로그인 하세요"
        
        // Do any additional setup after loading the view.
        //UserDefault.save(key: "A",value: "TEST")
        //UserDefault.delete(key: "name")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let A = UserDefault.load(key:"name")
        
        if(!A.isEmpty)
        {
            MyMessage.text = A+"님~!\n오늘도 많이 웃으세요"
            MyName.isHidden = true
            LoginBtn.isHidden = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let next = storyboard.instantiateViewController(withIdentifier: "aa")as! SWRevealViewController
            self.navigationController?.pushViewController(next, animated: true)
            
            //self.dismiss(animated: false, completion: nil)
            //self.performSegue(withIdentifier: "Init", sender: self)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        self.onHttpRequest("A")
    }
    
    @IBAction func onHttpRequest(_ sender: Any) {
        let strUrl : String = "http://www.godowon.com/m/check_admin_member_no.gdw?member_name=" + MyName.text!;
        let api = strUrl
        
        //URL에 한글이 있기 때문에 인코딩 해준다
        let encoding = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //URL생성
        let url = URL(string: encoding!)
        
        if let _url = url {
            var request = URLRequest(url: _url)
            request.httpMethod = "get" //get : Get 방식, post : Post 방식
            
            //header 설정
            //            request.setValue("", forHTTPHeaderField: "")
            //post body 설정
            //            var requestBody : String = ""
            //            request.httpBody = requestBody.data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                //error 일경우 종료
                guard error == nil && data != nil else {
                    if let err = error {
                        print(err.localizedDescription)
                    }
                    return
                }
                
                //data 가져오기
                if let _data = data {
                    if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                        let str = String(strData)
                        print(str)
                        
                        let jsonData = self.convertToDictionary(text: str)
                        var msg = jsonData?["msg"] as? String
                        var name = jsonData?["member_name"] as? String
                        name = name?.removingPercentEncoding
                        
                        var gdw_mem_no = jsonData?["gdw_mem_no"] as? String
                        var goc_mem_no = jsonData?["goc_mem_no"] as? String
                        
                        if(msg?.isEqual("NO_INPUT_MEMBER"))!
                        {
                            msg = "이름을 입력해주세요"
                        }
                        
                        if(msg?.isEqual("NO_MEMBER_FOUND"))!
                        {
                            msg = "아침지기로 등록되지 않은 이름입니다"
                        }
                        
                        if(msg?.isEqual("SUCCESS"))!
                        {
                            UserDefault.save(key: "name",value: name!)
                            UserDefault.save(key: "gdw_mem_no",value: gdw_mem_no!)
                            UserDefault.save(key: "goc_mem_no",value: goc_mem_no!)
                            
                        }
                        
                        //메인쓰레드에서 출력하기 위해
                        DispatchQueue.main.async {
                            self.MyMessage.text = msg
                            
                            if(msg?.isEqual("SUCCESS"))!
                            {
                                self.viewDidLoad()
                            }
                            
                        }
                    }
                }else{
                    print("data nil")
                }
            })
            task.resume()
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
