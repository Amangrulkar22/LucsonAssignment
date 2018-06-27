//
//  SignupViewController.swift
//  LucsonAssignment
//
//  Created by Ashwinkumar Mangrulkar on 26/06/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupViewController: UIViewController {
    
    /// textfield name
    @IBOutlet weak var txtName: UITextField!
    
    /// textfield username
    @IBOutlet weak var txtUsername: UITextField!
    
    /// textfield email
    @IBOutlet weak var txtEmail: UITextField!
    
    /// textfield password
    @IBOutlet weak var txtPassword: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    /// Back action
    ///
    /// - Parameter sender: button object
    @IBAction func backAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    /// Signup action
    ///
    /// - Parameter sender: button object
    @IBAction func signupAction(_ sender: Any) {
        
        guard let name = txtName.text, let username = txtUsername.text, let email = txtEmail.text, let password = txtPassword.text else {
            return
        }
        
        // configure signup model
        var signupModel = SignupModel()
        signupModel.name = name
        signupModel.username = username
        signupModel.email = email
        signupModel.password = password
        
        SVProgressHUD.show()
        
        DatabaseManager.sharedInstance.userSignup(signupModel) { (success, error) in
            SVProgressHUD.dismiss()
            
            if success {
                CustomAlertView.showPositiveAlert("User Registered successfully")
                
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
