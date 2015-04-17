//
//  LoginViewController.swift
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIAlertViewDelegate{

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.userInteractionEnabled = true
    }
    @IBAction func onCancelButtonPressed(sender: UIButton) {
        
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }

    @IBAction func onLoginButtonTapped(sender: UIButton)
    {
        self.logIn()
    }

    func logIn()
    {

    PFUser.logInWithUsernameInBackground(self.emailTextField.text, password:self.passwordTextField.text) {
    (user: PFUser!, error: NSError!) -> Void in
    if user != nil
    {
        let mapStoryBoard = UIStoryboard(name: "Map", bundle: nil)
        let tabBarVC = mapStoryBoard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UIViewController
        self.presentViewController(tabBarVC, animated: true, completion: nil)

    } else
    {
        var errorString = error.userInfo?["error"] as? NSString
        self.showAlert(errorString!)
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
