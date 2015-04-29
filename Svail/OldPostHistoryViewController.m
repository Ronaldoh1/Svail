//
//  PostHistoryViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "OldPostHistoryViewController.h"
#import "PostDetailViewController.h"
#import <Parse/Parse.h>
#import "Service.h"

@interface OldPostHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *arrayOfServiceObjects;
@property Service *serviceFromParse;
@property Service *serviceSelected;
@property NSIndexPath *itemToDeletIndexPath;
@end

@implementation OldPostHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.serviceFromParse = [Service new];

    self.navigationItem.hidesBackButton = true;
   PFQuery *query = [Service query];
    [query whereKey:@"provider" equalTo:[User currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu objects.", (unsigned long)objects.count);

            self.arrayOfServiceObjects = objects.mutableCopy;

           [self.tableView reloadData];


        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    

}



- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    UIViewController *mapTabVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mapTabVC animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    self.serviceFromParse = self.arrayOfServiceObjects[indexPath.row];

    cell.textLabel.text = self.serviceFromParse.title;
    cell.detailTextLabel.text = self.serviceFromParse.category;

    return cell;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    self.serviceSelected = ((Service *)self.arrayOfServiceObjects[indexPath.row]);
//
//    NSLog(@"%@", self.serviceSelected.title);
//
//}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    return @"Delete Service";
}
//check for table for delete mode and display the alert.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle ==UITableViewCellEditingStyleDelete){
         self.itemToDeletIndexPath = indexPath;

        [self displayAlert];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    //button index 0 means the user presses the cancel button.
    if (buttonIndex == 0) {


    }else{
        //else this means that the user click on delete and should continue to remove the item from

        //we also need to remove this item from parse.
        Service *serviceToDelete = self.arrayOfServiceObjects[self.itemToDeletIndexPath.row];

        [serviceToDelete deleteInBackground];


        [self.arrayOfServiceObjects removeObjectAtIndex:self.itemToDeletIndexPath.row];



        [self.tableView reloadData]; // tell table to refresh now

        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrayOfServiceObjects.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    PostDetailViewController *postDetailVC = segue.destinationViewController;

     self.serviceSelected =
    postDetailVC.serviceToViewEdit = ((Service *)self.arrayOfServiceObjects[[self.tableView indexPathForSelectedRow].row]);


}
-(IBAction)unwindSegueFromPostDetailViewController:(UIStoryboardSegue *)segue{

}

#pragma Marks - Helper Methods. 

-(void) displayAlert{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Service?" message:@"Are you sure want to delete this service from Svail?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];

    [alert show];
}

@end
