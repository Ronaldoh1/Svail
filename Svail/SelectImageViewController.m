//
//  SelectImageViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "SelectImageViewController.h"
#import "MBProgressHUD.h"
#import "Image.h"

@interface SelectImageViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property Image *pickedImage1;
@property Image *pickedImage2;
@property Image *pickedImage3;
@property Image *pickedImage4;
@property NSMutableArray *imageArray;
@property BOOL firstImagePicked;
@property BOOL secondImagePicked;
@property BOOL thirdImagePicked;
@property BOOL fourthImagePicked;

@end

@implementation SelectImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArray = [NSMutableArray new];
    self.pickedImage1 = [Image object];
    self.pickedImage2 = [Image object];
    self.pickedImage3 = [Image object];
    self.pickedImage4 = [Image object];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];


    self.navigationItem.hidesBackButton = true;

    if (self.imageArray.count == 1) {
        self.image1.image = (UIImage *)(self.imageArray[0]);
        self.image1.clipsToBounds = true;


    } else if(self.imageArray.count == 2){
        self.image1.image = (UIImage *)(self.imageArray[0]);
        self.image1.clipsToBounds = true;
        self.image2.image = (UIImage *)(self.imageArray[1]);
        self.image2.clipsToBounds = true;

    } else if(self.imageArray.count == 3){
        self.image1.image = (UIImage *)(self.imageArray[0]);
        self.image1.clipsToBounds = true;
        self.image2.image = (UIImage *)(self.imageArray[1]);
        self.image2.clipsToBounds = true;
        self.image3.image = (UIImage *)(self.imageArray[2]);
        self.image3.clipsToBounds = true;

    }  else if(self.imageArray.count == 4){
        self.image1.image = (UIImage *)(self.imageArray[0]);
        self.image1.clipsToBounds = true;
        self.image2.image = (UIImage *)(self.imageArray[1]);
        self.image2.clipsToBounds = true;
        self.image3.image = (UIImage *)(self.imageArray[2]);
        self.image3.clipsToBounds = true;
        self.image4.image = (UIImage *)(self.imageArray[3]);
        self.image4.clipsToBounds = true;
    }
}




- (IBAction)pickFirstImageButtonTapped:(UIButton *)sender {
    self.firstImagePicked = true;
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = true;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    [self presentViewController:picker animated:YES completion:nil];

}

- (IBAction)pickSecondImageButtonTapped:(UIButton *)sender {

    self.secondImagePicked = true;

    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = true;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)pickThirdImageButtonTapped:(UIButton *)sender {
    self.thirdImagePicked = true;

    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = true;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    [self presentViewController:picker animated:YES completion:nil];

}

- (IBAction)pickFourthImageButtonTapped:(UIButton *)sender {
    self.fourthImagePicked = true;

    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = true;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)onSaveImageButtonTapped:(UIBarButtonItem *)sender {

    //MARK - Save images//
    if (self.imageArray.count == 1) {

        //define and NSMutable array to hold the image objects.
        NSMutableArray *imageTempArray = [NSMutableArray new];

        NSData *imageData = UIImagePNGRepresentation((UIImage *)self.imageArray[0]);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        self.pickedImage1.imageFile = imageFile;
        // self.pickedImage1.service = self.service;
        [imageTempArray addObject:self.pickedImage1];

        [self saveImagesInBackGround:imageTempArray];





    }else if(self.imageArray.count == 2){

        //define and NSMutable array to hold the image objects.
        NSMutableArray *imageTempArray = [NSMutableArray new];

        //image1
        NSData *imageData = UIImagePNGRepresentation((UIImage *)self.imageArray[0]);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        self.pickedImage1.imageFile = imageFile;
        [imageTempArray addObject:self.pickedImage1];

        //image2
        NSData *imageData2 = UIImagePNGRepresentation((UIImage *)self.imageArray[1]);
        PFFile *imageFile2 = [PFFile fileWithData:imageData2];
        self.pickedImage2.imageFile = imageFile2;
        //self.pickedImage2.service = self.service;
        [imageTempArray addObject:self.pickedImage2];
        //[self.pickedImage2 saveInBackground];

        [self saveImagesInBackGround:imageTempArray];



    }else if(self.imageArray.count == 3){

        //define and NSMutable array to hold the image objects.
        NSMutableArray *imageTempArray = [NSMutableArray new];


        //image1
        NSData *imageData = UIImagePNGRepresentation((UIImage *)self.imageArray[0]);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        self.pickedImage1.imageFile = imageFile;
        [imageTempArray addObject:self.pickedImage1];

        //image2
        NSData *imageData2 = UIImagePNGRepresentation((UIImage *)self.imageArray[1]);
        PFFile *imageFile2 = [PFFile fileWithData:imageData2];
        self.pickedImage2.imageFile = imageFile2;
        //self.pickedImage2.service = self.service;
        [imageTempArray addObject:self.pickedImage2];

        //Image3
        NSData *imageData3 = UIImagePNGRepresentation((UIImage *)self.imageArray[2]);
        PFFile *imageFile3 = [PFFile fileWithData:imageData3];
        self.pickedImage3.imageFile = imageFile3;
        //self.pickedImage2.service = self.service;
        [imageTempArray addObject:self.pickedImage3];

        [self saveImagesInBackGround:imageTempArray];

    } if(self.imageArray.count == 4){
        //define and NSMutable array to hold the image objects.
        NSMutableArray *imageTempArray = [NSMutableArray new];

        //image1
        NSData *imageData = UIImagePNGRepresentation((UIImage *)self.imageArray[0]);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        self.pickedImage1.imageFile = imageFile;
        [imageTempArray addObject:self.pickedImage1];
        //image2
        NSData *imageData2 = UIImagePNGRepresentation((UIImage *)self.imageArray[1]);
        PFFile *imageFile2 = [PFFile fileWithData:imageData2];
        self.pickedImage2.imageFile = imageFile2;
        //self.pickedImage2.service = self.service;
        [imageTempArray addObject:self.pickedImage2];

        //Image3
        NSData *imageData3 = UIImagePNGRepresentation((UIImage *)self.imageArray[2]);
        PFFile *imageFile3 = [PFFile fileWithData:imageData3];
        self.pickedImage3.imageFile = imageFile3;
        //self.pickedImage2.service = self.service;
        [imageTempArray addObject:self.pickedImage3];
        //Image4
        NSData *imageData4 = UIImagePNGRepresentation((UIImage *)self.imageArray[3]);
        PFFile *imageFile4 = [PFFile fileWithData:imageData4];
        self.pickedImage4.imageFile = imageFile4;
        //self.pickedImage2.service = self.service;
        [imageTempArray addObject:self.pickedImage4];

        [self saveImagesInBackGround:imageTempArray];

    }


}
- (IBAction)onSkipButtonTapped:(UIButton *)sender {

    [self performSegueWithIdentifier:@"toServiceHistory"sender:self];
}

//Helper method to save all images in background;

-(void)saveImagesInBackGround:(NSMutableArray *)imagesHolder{

    //Indicator starts annimating when user saves images.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.9 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){


        [Image saveAllInBackground:imagesHolder block:^(BOOL succeeded, NSError *error) {



            if(!error){
                //successfully saved image1.
                [self performSegueWithIdentifier:@"toServiceHistory"sender:self];

            }else {
                [self displayErrorAlert:error.localizedDescription];

            }

        }];
        //stop actiivity indication from annimating.

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

//Helper method to dismissview picker View Controller.
-(void)cancelPicker{
    [self dismissViewControllerAnimated:true completion:nil];


}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self cancelPicker];

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

    //if the user picks the first image, then
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
    }else if(self.secondImagePicked == true){
        self.secondImagePicked = false;

        if (self.imageArray.count != 2){


            UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
            [self.imageArray insertObject:image atIndex:1];



        } else if (self.imageArray.count == 2) {
            [self.imageArray removeObjectAtIndex:1];
            UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
            [self.imageArray insertObject:image atIndex:1];


        }
    }else if(self.thirdImagePicked == true){
        self.thirdImagePicked = false;

        if (self.imageArray.count != 3){


            UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
            [self.imageArray insertObject:image atIndex:2];



        } else if (self.imageArray.count == 3) {
            [self.imageArray removeObjectAtIndex:2];
            UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
            [self.imageArray insertObject:image atIndex:2];
            
            
        }
    }else if(self.fourthImagePicked == true){
        self.fourthImagePicked = false;
        
        if (self.imageArray.count != 4){
            
            
            UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
            [self.imageArray insertObject:image atIndex:3];
            
            
            
        } else if (self.imageArray.count == 4) {
            [self.imageArray removeObjectAtIndex:3];
            UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
            [self.imageArray insertObject:image atIndex:3];
            
            
        }
    }
    
    
    
    
    [self dismissViewControllerAnimated:picker completion:nil];
    
    
}




@end
