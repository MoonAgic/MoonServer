//
//  ViewController.swift
//  MoonTest
//
//  Created by Moon on 25/02/2017.
//  Copyright © 2017 Moon. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var passwd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onRegistClicked(_ sender: Any) {
        let Headers = [
            "Content-Type": "application/json"
        ]
        let parameters:[String: String] = [
            "account": account.text!,
            "passwd": passwd.text!
        ]
        Alamofire.request("https://api.koik.io/regist", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: Headers).responseJSON {
            response in
            let dic:Dictionary = response.result.value as! Dictionary<String, Any>
            print("\(dic)")
            
            
        }
    }
    
    @IBAction func onLoginCLicked(_ sender: Any) {
        let Headers = [
            "Content-Type": "application/json"
        ]
        let parameters:[String: String] = [
            "account": account.text!,
            "passwd": passwd.text!
        ]
        Alamofire.request("https://api.koik.io/login", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: Headers).responseJSON {
            response in
            let dic = response.result.value as! Dictionary<String, Any>
            print("\(dic)")
            
            
        }
    }

}

