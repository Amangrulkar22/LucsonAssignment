//
//  SignupViewController.swift
//  LucsonAssignment
//
//  Created by Ashwinkumar Mangrulkar on 26/06/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class SignupViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signupAction(_ sender: Any) {
        
        guard let name = txtName.text, let username = txtUsername.text, let email = txtEmail.text, let password = txtPassword.text else {
            return
        }
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, err) in
            
            SVProgressHUD.dismiss()
            
            if err != nil {
                CustomAlertView.showNegativeAlert((err?.localizedDescription)!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //Successfully authenticated user
            self.ref = Database.database().reference(fromURL: "https://lucsonassignment.firebaseio.com/")
            let usersReference = self.ref?.child("users").child(uid)
            let values = ["name": name, "username": username, "email": email]
            
            usersReference?.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    CustomAlertView.showNegativeAlert((err?.localizedDescription)!)
                    return
                }
                
                // show registration successful message
                CustomAlertView.showPositiveAlert("User Registered successfully")
                
                let homeObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homeObj, animated: true)
                
            })
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
