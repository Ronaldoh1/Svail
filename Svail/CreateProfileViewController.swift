//
//  CreateProfileViewController.swift
//  Svail
//
//  Created by Mert Akanay on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var specialtyTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    var currentUser: User = User()

    override func viewDidLoad() {
        super.viewDidLoad()

      

        self.view.userInteractionEnabled = true

        self.currentUser = User.currentUser()!
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

            self.currentUser["name"] = fullNameTextField.text
            self.currentUser["gender"] = genderTextField.text
            self.currentUser["city"] = cityTextField.text
            self.currentUser["state"] = stateTextField.text
            self.currentUser["specialty"] = specialtyTextField.text
            self.currentUser["occupation"] = occupationTextField.text

            self.currentUser.save()

            let verificationStoryBoard = UIStoryboard(name: "Verification", bundle: nil)
            let navBarVC = verificationStoryBoard.instantiateViewControllerWithIdentifier("VeriNavVC") as! UIViewController
            self.presentViewController(navBarVC, animated: true, completion: nil)


        }

//        if (signUpError != "")
//        {
//            self.showAlert(signUpError)
//        }
    }

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
