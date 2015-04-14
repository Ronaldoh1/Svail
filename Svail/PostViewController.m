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


@interface PostViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UITextField *serviceTitle;
@property (weak, nonatomic) IBOutlet UITextField *serviceDescription;
@property (weak, nonatomic) IBOutlet UITextField *serviceCategory;
@property (weak, nonatomic) IBOutlet UITextField *serviceCapacity;
@property (weak, nonatomic) IBOutlet UITextField *travel;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *availability;
@property Image *pickedImage1;
@property Product * service;



@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.




}

- (IBAction)pickFirstImage:(UIButton *)sender {

   UIImagePickerController* picker = [UIImagePickerController new];
   picker.delegate = self;
    picker.allowsEditing = true;
   [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

   [self presentViewController:picker animated:YES completion:nil];



}



- (IBAction)onPostButtonTapped:(UIBarButtonItem *)sender {
    self.service.title = self.serviceTitle.text;
    self.service.description = self.serviceDescription.text;
    self.service.category = self.serviceCategory.text;
    self.service.capacity = ((NSNumber *)self.serviceCapacity.text);





}

- (IBAction)onBackButtonTapped:(UIBarButtonItem *)sender {
}
-(void)cancelPicker{
    [self dismissViewControllerAnimated:true completion:nil];


}

#pragma MARKs - Image Pickers
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{


        UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];

        self.image1.image = image;
        self.image1.clipsToBounds = true;

    [self dismissViewControllerAnimated:picker completion:nil];



}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self cancelPicker];

}


@end
