//
//  SigninViewController.swift
//  LucsonAssignment
//
//  Created by Ashwinkumar Mangrulkar on 26/06/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SigninViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txtEmail.text = "q@gmail.com"
        txtPassword.text = "123456"
    }
    
    @IBAction func signinAction(_ sender: Any) {
        
        guard let email = txtEmail.text, let password = txtPassword.text else {
            print("credetials are not valid")
            return
        }
        
        SVProgressHUD.show()
        
        Auth.auth().signInAndRetrieveData(withEmail: email, password: password) { (user, err) in
            
            SVProgressHUD.dismiss()
            
            if err != nil {
                CustomAlertView.showNegativeAlert((err?.localizedDescription)!)
                return
            }
            
            let homeObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeObj, animated: true)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

