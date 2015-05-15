//
//  SignUpViewController.swift
//  Svail
//
//  Created by Mert Akanay on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{


    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var kbHeight: CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.orangeColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]

//        self.view.backgroundColor = UIColor(red: 240/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1.0)

        //making the buttons round
        self.cancelButton.clipsToBounds = true
        self.cancelButton.layer.cornerRadius = 60/2.0
        self.cancelButton.backgroundColor = UIColor(red: 255/255.0, green: 127/255.0, blue: 59/255.0, alpha: 1.0)
        self.cancelButton.layer.borderColor = UIColor.redColor() as! CGColor;
        self.cancelButton.layer.borderWidth = 2.0

        self.registerButton.clipsToBounds = true
        self.registerButton.layer.cornerRadius = 60/2.0
        self.registerButton.backgroundColor = UIColor(red: 59/255.0, green: 185/255.0, blue: 255/255.0, alpha: 1.0)
        self.registerButton.layer.borderColor = UIColor.redColor() as! CGColor;
        self.registerButton.layer.borderWidth = 2.0

//        //Dismiss keyboard
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        //setuptextfield delegates
        self.setUpTextFields()
    }
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }

    @IBAction func onFbLoginButtonTapped(sender: AnyObject) {

        var permissions = ["email", "public_profile"]

        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in

            if let user = user as? User{
                if user.isNew {
                    println("User signed up and logged in through Facebook!")

                    PFQuery.clearAllCachedResults()



                    user.isFbUser = true

                    //set the number of post;
                    user.numberOfPosts = 0

                    self.getFacebookUserData()

//                    user.saveInBackgroundWithBlock {
//                        (success: Bool, error: NSError?) -> Void in
//                        if (success) {
//                            self.performSegueWithIdentifier("toCreateProfileSegue", sender: self)
//                            
//
//                        } else {
//                            PFQuery.clearAllCachedResults();
//                            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                            let mainTabBarVC = mainStoryBoard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UIViewController
//                            self.presentViewController(mainTabBarVC, animated: true, completion: nil)
//
//                        }
//                    }//                    let mapStoryboard = UIStoryboard(name: "EditProfile", bundle: nil)
//                    let editProfileNavVC = mapStoryboard.instantiateViewControllerWithIdentifier("editProfileNavVC") as! UINavigationController
//                    self.presentViewController(editProfileNavVC, animated: true, completion: nil)


                } else {
                    println("User logged in through Facebook!")

                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainVCTab = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UITabBarController
                    self.presentViewController(mainVCTab, animated: true, completion: nil)

                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }

    }

    @IBAction func onRegisterButtonTapped(sender: UIButton)
    {
        var signUpError = ""

        if (self.emailTextField.text == "" || self.passwordTextField.text == "" || self.confirmPasswordTextField.text == "" || self.phoneNumberTextField.text == ""){

            signUpError = "One or more fields are blank. Please try again!"

        }else if (self.passwordTextField.text != self.confirmPasswordTextField.text){

            signUpError = "Passwords do not match, please try again.";

        }else if (count(self.passwordTextField.text) < 6 || count(self.confirmPasswordTextField.text) < 6)
        {

            signUpError = "Password must be at least 6 characters long. Please try again."
        }else{

            self.signUp()

        }

        if (signUpError != "")
        {
            self.showAlert(signUpError)
        }
    }


    //helper method to sign up user with parse.
    func signUp() {
        var user = User()
        user.email = emailTextField.text
        user.username = user.email
        user.password = passwordTextField.text
        user.isFbUser = false
        user.numberOfPosts = 0
        // other fields can be set just like with PFObject
        user["phoneNumber"] = phoneNumberTextField.text

        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {

                //if sign up is successful then send the user to edit profile.
//                let mapStoryboard = UIStoryboard(name: "EditProfile", bundle: nil)
//                let editProfileNavVC = mapStoryboard.instantiateViewControllerWithIdentifier("editProfileNavVC") as! UITabBarController
//                self.presentViewController(editProfileNavVC, animated: true, completion: nil)
                
                PFQuery.clearAllCachedResults();

                self.performSegueWithIdentifier("toCreateProfileSegue", sender: self)


            } else {
                if let errorString = error!.userInfo?["error"] as? NSString
                {
                    self.showAlert(errorString)
                }

            }
        }
    }

    //helper method to get user data from facebook.

    func getFacebookUserData(){

        var user = User.currentUser()

        var fbRequest = FBSDKGraphRequest(graphPath:"/me", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in



            if error == nil {


                user?.name = result["name"] as! String

                user?.email = result["email"] as? String

                user?.gender = result["gender"] as! String

                println(result["picture"])

                user?.saveInBackground()

                var facebookID = result["id"] as? String



                // self.getFbUserProfileImage(result)

                //self.getFbUserProfileImage()
                self.getFbUserProfileImage(facebookID!)
                
                
            } else {
                
                println("Error Getting Friends \(error)");
                
            }
        }
        
    }

    //getFacebook Profile Image



    func getFbUserProfileImage(facebookID :String){
        // Get user profile pic


        let url = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large")
        let urlRequest = NSURLRequest(URL: url!)

        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in

            print(data);

            let newUser = User.currentUser()
            // Display the image
            //let image = UIImage(data: data)
            // self.profilePic.image = image

            var file = PFFile(data: data)

            newUser!.profileImage = file;

           // User.currentUser()?.saveInBackground()
            
            newUser!.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.performSegueWithIdentifier("toCreateProfileSegue", sender: self)

//            User.currentUser()?.saveInBackground()

                } else {
                    PFQuery.clearAllCachedResults();
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarVC = mainStoryBoard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UIViewController
                    self.presentViewController(mainTabBarVC, animated: true, completion: nil)

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
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }

    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    func setUpTextFields(){
        
        
        self.phoneNumberTextField.delegate = self;
        self.confirmPasswordTextField.delegate = self;
        self.passwordTextField.delegate = self;
        self.emailTextField.delegate = self;
        
        
        
    }
    
    
}
