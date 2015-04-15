//
//  PostViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PostViewController.h"
#import "Image.h"
#import "Product.h"
#import <Parse/Parse.h>
#import "Service.h"
#import "User.h"



@interface PostViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UITextField *serviceTitle;
@property (weak, nonatomic) IBOutlet UITextField *serviceDescription;
@property (weak, nonatomic) IBOutlet UITextField *serviceCategory;
@property (weak, nonatomic) IBOutlet UITextField *serviceCapacity;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *availability;
@property Image *pickedImage1;
@property Image *pickedImage2;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property Service *service;
@property NSMutableArray *imageArray;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlPicker;
@property BOOL firstImagePicked;
@property User *currentUser;


@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArray = [NSMutableArray new];
    self.service = [Service new];
    self.pickedImage1 = [Image object];
    self.pickedImage2 = [Image object];






}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];


    if (self.imageArray.count == 1) {
        self.image1.image = (UIImage *)(self.imageArray[0]);
        self.image1.clipsToBounds = true;



    } else if(self.imageArray.count == 2){
        self.image1.image = (UIImage *)(self.imageArray[0]);
        self.image1.clipsToBounds = true;
        self.image2.image = (UIImage *)(self.imageArray[1]);
        self.image2.clipsToBounds = true;

    }

}
- (IBAction)onBackButtonTapped:(UIBarButtonItem *)sender {
    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UIViewController *mapTabVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mapTabVC animated:true completion:nil];
}

- (IBAction)pickFirstImage:(UIButton *)sender {

    self.firstImagePicked = true;

   UIImagePickerController* picker = [UIImagePickerController new];
   picker.delegate = self;
    picker.allowsEditing = true;
   [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

   [self presentViewController:picker animated:YES completion:nil];



}

- (IBAction)pickSecondImage:(UIButton *)sender {
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = true;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    [self presentViewController:picker animated:YES completion:nil];

}


- (IBAction)onPostButtonTapped:(UIBarButtonItem *)sender {

    NSString *errorMessage = @"Error in from. Please note - All fields are required";

    if ([self.serviceTitle.text isEqualToString:@""] || [self.serviceDescription.text isEqualToString:@""] || [self.serviceCategory.text isEqualToString:@""] || [self.serviceCapacity.text isEqualToString:@""] || [self.location.text isEqualToString:@""]) {

        [self displayErrorAlert:errorMessage];


    }else{

    //MARK - Save Service information
//        self.currentUser = [PFUser user];
//    self.currentUser.username = @"bitchesBeLike";
        [self.currentUser save];
     self.service.provider = self.currentUser;
    self.service.title = self.serviceTitle.text;
    self.service.description = self.serviceDescription.text;
    self.service.category = self.serviceCategory.text;
    self.service.capacity = ((NSNumber *)self.serviceCapacity.text);
    self.service.location = self.location.text;
    if (self.segmentedControlPicker.selectedSegmentIndex == 0) {
        self.service.travel = false;
    }else if (self.segmentedControlPicker.selectedSegmentIndex == 1){
        self.service.travel = true;
    }

    //Indicator starts annimating when signing up.
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.color = [UIColor colorWithRed:102 green:0 blue:255 alpha:1];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];

    [activityIndicator startAnimating];
    [self.service saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        //stop actiivity indication from annimating.
        [activityIndicator stopAnimating];


        if (!error) {
            [self displaySuccessMessage:@"You Service has been posted"];

            [self performSegueWithIdentifier:@"toServiceHistory" sender:self];
        }else{
            [self displayErrorAlert:error.localizedDescription];


            
            
        }
    }];

    //MARK - Save images//
    NSData *imageData = UIImagePNGRepresentation((UIImage *)self.imageArray[0]);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    self.pickedImage1.imageFile = imageFile;
    self.pickedImage1.service = self.service;
    [self.pickedImage1 saveInBackground];

        if(self.imageArray.count == 2){
    NSData *imageData2 = UIImagePNGRepresentation((UIImage *)self.imageArray[1]);
    PFFile *imageFile2 = [PFFile fileWithData:imageData2];
    self.pickedImage2.imageFile = imageFile2;
    self.pickedImage2.service = self.service;
    [self.pickedImage2 saveInBackground];

        }





    }


}


-(void)cancelPicker{
    [self dismissViewControllerAnimated:true completion:nil];


}

//hide keyboard when user touches outside.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



//Helper method to display error to user.
-(void)displayErrorAlert:(NSString *)error{


    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error in form" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [alertView show];
    
}

//Helper method to display success message to user.
-(void)displaySuccessMessage:(NSString *)text{


    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success!" message:text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [alertView show];
    
}


#pragma MARKs - Image Pickers
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    if (self.firstImagePicked == true) {
        self.firstImagePicked = false;

    if (self.imageArray.count == 0) {

        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
        [self.imageArray addObject:image];


    }else if (self.imageArray[0] != nil){
        [self.imageArray removeObjectAtIndex:0];

        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
        [self.imageArray insertObject:image atIndex:0];


        }
    }else{

       if (self.imageArray.count != 2){


        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
        [self.imageArray insertObject:image atIndex:1];

        
        
    } else if (self.imageArray.count == 2) {
        [self.imageArray removeObjectAtIndex:1];
        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
        [self.imageArray insertObject:image atIndex:1];


        }
    }
    [self dismissViewControllerAnimated:picker completion:nil];


}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self cancelPicker];

}


@end
