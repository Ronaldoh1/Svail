//
//  SignUpViewController.swift
//  Svail
//
//  Created by Mert Akanay on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.userInteractionEnabled = true
        
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }

    @IBAction func onCancelButtonTapped(sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewControllerWithIdentifier("rootVC") as! UIViewController
        self.presentViewController(mainVC, animated: true, completion: nil)
    }
    @IBAction func onRegisterButtonTapped(sender: UIButton)
    {
        var signUpError = ""

        if (self.emailTextField.text == "" || self.passwordTextField.text == "" || self.confirmPasswordTextField.text == "" || self.phoneNumberTextField.text == "")
        {

            signUpError = "One or more fields are blank. Please try again!"

        }else if (self.passwordTextField.text != self.confirmPasswordTextField.text){

            signUpError = "Passwords do not match, please try again.";

        }else if (count(self.passwordTextField.text) < 1 || count(self.confirmPasswordTextField.text) < 1)
        {
            
            signUpError = "Password must be at least 1 characters long. Please try again."
        }else{

            self.signUp()

        }

        if (signUpError != "")
        {
            self.showAlert(signUpError)
        }
    }


    func signUp() {
        var user = PFUser()
        user.username = emailTextField.text
        user.password = passwordTextField.text
        // other fields can be set just like with PFObject
        user["phoneNumber"] = phoneNumberTextField.text

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
               self.performSegueWithIdentifier("toCreateProfileSegue", sender: self)
            } else {
                if let errorString = error!.userInfo?["error"] as? NSString
                {
                    self.showAlert(errorString)
                }

            }
        }
    }

    func showAlert(error:NSString)
    {

        let alertController = UIAlertController(title: "Error in form", message: error as String, preferredStyle: .Alert)

        let oKAction = UIAlertAction(title: "OK", style: .Cancel){

            (action) in
        }
        alertController.addAction(oKAction)

        self.presentViewController(alertController, animated: true) {
            
        }
        
    }

}
