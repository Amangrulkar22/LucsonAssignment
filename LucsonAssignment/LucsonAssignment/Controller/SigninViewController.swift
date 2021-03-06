//
//  SigninViewController.swift
//  LucsonAssignment
//
//  Created by Ashwinkumar Mangrulkar on 26/06/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit
import SVProgressHUD

class SigninViewController: UIViewController {
    
    /// textfield email
    @IBOutlet weak var txtEmail: UITextField!
    
    /// textfield password
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTextfield()
    }
    
    /// Reset textfield
    func resetTextfield() {
        txtEmail.text = ""
        txtPassword.text = ""
    }
        
    
    /// Signin actio method
    ///
    /// - Parameter sender: button object
    @IBAction func signinAction(_ sender: Any) {
        
        guard let email = txtEmail.text, let password = txtPassword.text else {
            print("credetials are not valid")
            return
        }
        
        // configure signin model
        var signinModel = SigninModel()
        signinModel.email = email
        signinModel.password = password
        
        SVProgressHUD.show()
        
        DatabaseManager.sharedInstance.userSignin(signinModel) { (success, error) in
            SVProgressHUD.dismiss()
            
            if success {
                let homeObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homeObj, animated: true)
            }else {
                CustomAlertView.showNegativeAlert((error?.localizedDescription)!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

