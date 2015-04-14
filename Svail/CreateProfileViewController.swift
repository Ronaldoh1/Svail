//
//  CreateProfileViewController.swift
//  Svail
//
//  Created by Mert Akanay on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

import UIKit
import Parse

class CreateProfileViewController: UIViewController {

    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var specialtyTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.userInteractionEnabled = true

    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }


    @IBAction func onSkipButtonPressed(sender: UIButton)
    {
        let mapStoryBoard = UIStoryboard(name: "Map", bundle: nil)
        let tabBarVC = mapStoryBoard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UIViewController
        self.presentViewController(tabBarVC, animated: true, completion: nil)
    }

    @IBAction func onFinishButtonPressed(sender: UIButton)
    {
        var signUpError = ""

        if (self.fullNameTextField.text == "" || self.genderTextField.text == "" || self.cityTextField.text == "" || self.stateTextField.text == "" || self.specialtyTextField.text == "" || self.occupationTextField.text == "")
        {

            signUpError = "One or more fields are blank. Please try again!"
            self.showAlert(signUpError)

        }else{

            var user = PFUser()
            user["name"] = fullNameTextField.text
            user["gender"] = genderTextField.text
            user["city"] = cityTextField.text
            user["state"] = stateTextField.text
            user["specialty"] = specialtyTextField.text
            user["occupation"] = occupationTextField.text


            let mapStoryBoard = UIStoryboard(name: "Map", bundle: nil)
            let tabBarVC = mapStoryBoard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UIViewController
            self.presentViewController(tabBarVC, animated: true, completion: nil)

            //NEED TO SAVE IN BACKGROUND

        }

//        if (signUpError != "")
//        {
//            self.showAlert(signUpError)
//        }
    }

//    func createProfile() {
//        var user = PFUser()
//        user["name"] = fullNameTextField.text
//        user["gender"] = genderTextField.text
//        user["city"] = cityTextField.text
//        user["state"] = stateTextField.text
//        user["specialty"] = specialtyTextField.text
//        user["occupation"] = occupationTextField.text
//
////        user.signUpInBackgroundWithBlock {
////            (succeeded: Bool, error: NSError?) -> Void in
//            if error == nil
//            {
//                let mapStoryBoard = UIStoryboard(name: "Map", bundle: nil)
//                let tabBarVC = mapStoryBoard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UIViewController
//                self.presentViewController(tabBarVC, animated: true, completion: nil)
//
//            } else {
//                if let errorString = error!.userInfo?["error"] as? NSString
//                {
//                    self.showAlert(errorString)
//                }
//
//            }
//        }
//    }

    func showAlert(error:NSString)
    {

        let alertController = UIAlertController(title: "Please fill all blanks or press skip button to do it later", message: error as String, preferredStyle: .Alert)

        let oKAction = UIAlertAction(title: "OK", style: .Cancel){

            (action) in
        }
        alertController.addAction(oKAction)

        self.presentViewController(alertController, animated: true) {
            
        }
        
    }
}
