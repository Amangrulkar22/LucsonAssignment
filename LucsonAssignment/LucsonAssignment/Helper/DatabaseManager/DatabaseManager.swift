//
//  DatabaseManager.swift
//  LucsonAssignment
//
//  Created by Ashwinkumar Mangrulkar on 27/06/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DatabaseManager: NSObject {
    
    /// DatabaseManager singleton object
    static let sharedInstance = DatabaseManager()
    
    /// Database reference
    var ref: DatabaseReference?
    
    /// User signup database method
    ///
    /// - Parameters:
    ///   - parameter: SignupModel object
    ///   - withCompletionHandler: Event trigger
    func userSignup(_ parameter:SignupModel, _ withCompletionHandler:@escaping (_ success:Bool, _ error:Error?)->Void) {
        Auth.auth().createUser(withEmail: parameter.email!, password: parameter.password!) { (user: User?, err) in
            
            if err != nil {
                withCompletionHandler(false, err)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //Successfully authenticated user
            self.ref = Database.database().reference(fromURL: Firebase_Database_Url)
            let usersReference = self.ref?.child(UserTable).child(uid)
            let values = ["name": parameter.name!, "username": parameter.username!, "email": parameter.email!]
            
            usersReference?.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    withCompletionHandler(false, err)
                    return
                }
                
                // show registration successful message
                withCompletionHandler(true, nil)
                
            })
        }
    }
    
    /// User signin database method
    ///
    /// - Parameters:
    ///   - parameter: SigninModel object
    ///   - withCompletionHandler: Event trigger
    func userSignin(_ parameter:SigninModel, _ withCompletionHandler:@escaping (_ success:Bool, _ error:Error?)->Void)
    {
        Auth.auth().signInAndRetrieveData(withEmail: parameter.email!, password: parameter.password!) { (user, err) in
            
            if err != nil {
                withCompletionHandler(false, err)
                return
            }
            
            withCompletionHandler(true, nil)
        }
    }
    
    /// Signout database method
    ///
    /// - Parameter withCompletionHandler: Event trigger
    func userSignout(_ withCompletionHandler:@escaping (_ success:Bool, _ error:Error?)->Void)
    {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let err as NSError {
            print ("Error signing out: %@", err)
            withCompletionHandler(false, err)
        }
        withCompletionHandler(true, nil)
    }
}
