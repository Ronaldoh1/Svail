//
//  PostHistoryViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 4/14/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "PostHistoryViewController.h"
#import "PostDetailViewController.h"
#import <Parse/Parse.h>
#import "Service.h"

@interface PostHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *arrayOfServiceObjects;
@property Service *serviceFromParse;
@property Service *serviceSelected;
@end

@implementation PostHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.serviceFromParse = [Service new];

    self.navigationItem.hidesBackButton = true;
   PFQuery *query = [Service query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu objects.", (unsigned long)objects.count);

            self.arrayOfServiceObjects = objects.copy;



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



@end
