//
//  SignUpViewController.swift
//  Svail
//
//  Created by Mert Akanay on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{


    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Dismiss keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        //setuptextfield delegates
        self.setUpTextFields()
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }

    @IBAction func onFbLoginButtonTapped(sender: AnyObject) {

        var permissions = ["email", "public_profile"]

        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")

                    
                } else {
                    println("User logged in through Facebook!")

                    let mapStoryboard = UIStoryboard(name: "Map", bundle: nil)
                    let mapVCTab = mapStoryboard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UITabBarController
                    self.presentViewController(mapVCTab, animated: true, completion: nil)

                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }

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

    //helper method to retrieve user info from facebook. 
    
    //helper method to sign up user with parse.
    func signUp() {
        var user = User()
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

    //helper method to show alert
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

    //Helper methods to dismiss keyboard
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 190
    }

    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 190
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func setUpTextFields(){


        self.phoneNumberTextField.delegate = self;
        self.confirmPasswordTextField.delegate = self;
        self.passwordTextField.delegate = self;
        self.emailTextField.delegate = self;



    }

    
}
