//
//  CreateProfileViewController.swift
//  Svail
//
//  Created by Mert Akanay on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController, UIActionSheetDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!

    var currentUser: User = User()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.orangeColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]

//        self.view.backgroundColor = UIColor(red: 240/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1.0)

        self.profileImage.layer.cornerRadius = 120/2.0
        self.profileImage.clipsToBounds = true
        
        //making the buttons round
        self.skipButton.clipsToBounds = true
        self.skipButton.layer.cornerRadius = 60/2.0
        self.skipButton.backgroundColor = UIColor(red: 255/255.0, green: 127/255.0, blue: 59/255.0, alpha: 1.0)
        self.skipButton.layer.borderColor = UIColor.redColor() as! CGColor;
        self.skipButton.layer.borderWidth = 2.0

        self.finishButton.clipsToBounds = true
        self.finishButton.layer.cornerRadius = 60/2.0
        self.finishButton.backgroundColor = UIColor(red: 59/255.0, green: 185/255.0, blue: 255/255.0, alpha: 1.0)
        self.finishButton.layer.borderColor = UIColor.redColor() as! CGColor;
        self.finishButton.layer.borderWidth = 2.0

        self.view.userInteractionEnabled = true

        self.currentUser = User.currentUser()!

        //Dismiss keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        //setuptextfield delegates
        self.setUpTextFields()


    }
    override func viewWillAppear(animated: Bool) {
        
        if (self.currentUser.isFbUser == true)
        {
            self.currentUser.profileImage.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.profileImage.image = image
                    }
                }
            }
        }else
        {
            self.profileImage.image = UIImage(named:"defaultimage")
            let image = UIImage(named:"defaultimage")
            let imageData = UIImagePNGRepresentation(image)
            let imageFile = PFFile(name:"image.png", data:imageData)
            self.currentUser.profileImage = imageFile
            currentUser.saveInBackground()
        }
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }


    @IBAction func onSkipButtonPressed(sender: UIButton)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVCTab = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UITabBarController
        self.presentViewController(mainVCTab, animated: true, completion: nil)
    }

    @IBAction func onFinishButtonPressed(sender: UIButton)
    {
        var signUpError = ""

        if (self.fullNameTextField.text == "" || self.genderTextField.text == "" || self.stateTextField.text == "" || self.occupationTextField.text == "")
        {

            signUpError = "One or more fields are blank. Please try again!"
            self.showAlert(signUpError)

        }else{

            self.currentUser["name"] = fullNameTextField.text
            self.currentUser["gender"] = genderTextField.text
            self.currentUser["state"] = stateTextField.text
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
    @IBAction func onChangePhotoButtonTapped(sender: UIButton)
    {
        let actionSheet = UIActionSheet(title:"Select Image for Profile", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "From Library", "From Camera")

        actionSheet.showInView(self.view)

    }

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1)
        {
            let pickerView = UIImagePickerController()
            pickerView.allowsEditing = true
            pickerView.delegate = self
            pickerView.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(pickerView, animated: true, completion: nil)
        }
        else if (buttonIndex == 0)
        {
            let pickerView = UIImagePickerController()
            pickerView.allowsEditing = true
            pickerView.delegate = self
            pickerView.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(pickerView, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        let img = info [UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImagePNGRepresentation(img)
        let imageFile = PFFile(data: imageData)
        self.currentUser.profileImage = imageFile
        self.profileImage.image = img
        self.currentUser.profileImage.saveInBackground()
        self.dismissViewControllerAnimated(true, completion: nil)
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


        self.occupationTextField.delegate = self
        self.genderTextField.delegate = self
        self.fullNameTextField.delegate = self
        self.stateTextField.delegate = self




    }
}
