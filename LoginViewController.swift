//
//  LoginViewController.swift
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIAlertViewDelegate, UITextFieldDelegate{


    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Dismiss keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        //setup textfield delegates
        self.setUpTextFieldsForLogin()

        self.view.userInteractionEnabled = true

        self.view.backgroundColor = UIColor(red: 240/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1.0)

        //making the buttons round
        self.cancelButton.clipsToBounds = true
        self.cancelButton.layer.cornerRadius = 60/2.0
        self.cancelButton.backgroundColor = UIColor(red: 255/255.0, green: 127/255.0, blue: 59/255.0, alpha: 1.0)
        self.cancelButton.layer.borderColor = UIColor.redColor() as! CGColor;
        self.cancelButton.layer.borderWidth = 2.0

        self.signInButton.clipsToBounds = true
        self.signInButton.layer.cornerRadius = 60/2.0
        self.signInButton.backgroundColor = UIColor(red: 59/255.0, green: 185/255.0, blue: 255/255.0, alpha: 1.0)
        self.signInButton.layer.borderColor = UIColor.redColor() as! CGColor;
        self.signInButton.layer.borderWidth = 2.0
    }
    @IBAction func onCancelButtonPressed(sender: UIButton) {

    }
    @IBAction func onLogInWithFbButtonTapped(sender: AnyObject) {

        var permissions = ["email", "public_profile"]

        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")

                    self.getFacebookUserData()

                    let mapStoryboard = UIStoryboard(name: "EditProfile", bundle: nil)
                    let editProfileNavVC = mapStoryboard.instantiateViewControllerWithIdentifier("editProfileNavVC") as! UINavigationController
                    self.presentViewController(editProfileNavVC, animated: true, completion: nil)

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

    @IBAction func onSignInButtonTapped(sender: AnyObject) {
        self.logIn()
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true)
    }


    func logIn(){


        PFUser.logInWithUsernameInBackground(self.emailTextField.text, password:self.passwordTextField.text) {
            (user, error) -> Void in
            if user != nil {
                //        let mapStoryBoard = UIStoryboard(name: "Map", bundle: nil)
                //        let tabBarVC = mapStoryBoard.instantiateViewControllerWithIdentifier("MainTabBarVC") as! UIViewController
                //        self.presentViewController(tabBarVC, animated: true, completion: nil)
                //
                let mapStoryBoard = UIStoryboard(name: "Verification", bundle: nil)
                let veriVC = mapStoryBoard.instantiateViewControllerWithIdentifier("VeriNavVC") as! UIViewController
                self.presentViewController(veriVC, animated: true, completion: nil)

            } else {
                var errorString = error!.userInfo?["error"] as? NSString
                self.showAlert(errorString!)
                //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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



    func getFbUserProfileImage(facebookID :String){
        // Get user profile pic


        let url = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large")
        let urlRequest = NSURLRequest(URL: url!)

        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in

            print(data);

            // Display the image
            //let image = UIImage(data: data)
            // self.profilePic.image = image

            var file = PFFile(data: data)

            User.currentUser()?.profileImage = file;

            User.currentUser()?.saveInBackground()


        }

    }


    //helper method to show alert.

    func showAlert(error:NSString){

        let alertController = UIAlertController(title: "Error in form", message: error as String, preferredStyle: .Alert)

        let oKAction = UIAlertAction(title: "OK", style: .Cancel){

            (action) in
        }
        alertController.addAction(oKAction)

        self.presentViewController(alertController, animated: true) {
            
        }
        
    }
    //MARK - Delegate method to dismiss keyboard.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Helper methods to dismiss keyboard
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 190
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 190
    }
    
    func setUpTextFieldsForLogin(){
        
        self.passwordTextField.delegate = self;
        self.emailTextField.delegate = self;
        
        
    }
    
}
