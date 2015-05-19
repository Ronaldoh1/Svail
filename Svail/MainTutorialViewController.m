//
//  MainTutorialViewController.m
//  Svail
//
//  Created by Ronald Hernandez on 5/13/15.
//  Copyright (c) 2015 Svail. All rights reserved.
//

#import "MainTutorialViewController.h"
#import "PageContentViewController.h"

@interface MainTutorialViewController () <UIPageViewControllerDataSource>

@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (nonatomic,strong) NSArray *arrayPageFirstLabel;
@property (nonatomic,strong) NSArray *arrayPageSecondLabel;
@property (nonatomic,strong) NSArray *arrayImages;

@end

@implementation MainTutorialViewController

@synthesize PageViewController,arrayPageFirstLabel;

- (void)viewDidLoad {
    [super viewDidLoad];

    //INITIAL SET UP

    //setup color tint
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:59/255.0 alpha:1.0];

    //setting image to Navigation Bar's title
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.font = [UIFont fontWithName:@"Noteworthy" size:20];
    titleView.text = @"Welcome to Svail";
    titleView.textColor = [UIColor colorWithRed:21/255.0 green:137/255.0 blue:255/255.0 alpha:1.0];
    [self.navigationItem setTitleView:titleView];


   self.arrayPageFirstLabel = @[@"Want to promote your service and earn some extra cash?",@"Concerned about meeting with strange people?",@"How much does it cost?", @"How can I purchase a full year subscription?", @"How do I get paid?", @"Advise for posting services", @"Requesting Services", @"Disclaimer"];

    self.arrayPageSecondLabel = @[@"Svail makes it possible by connecting you with people around your city!", @"Svail provides a verification system on all users. A checkmark like the one below is displayed for all verified users with a safety level of 5 or greater.",@"Svail is free for the first 14 service posts. After that, Svail is $1.99 for a full year subcription.", @"After your 14 post, you will be prompted to pay with your credit or Apple Pay. PS - We do not store credit card information.", @"Svail does not handle payments. We recommend you use other third party apps for payments such as Venmo, Paypal or Square.", @"Your service will be disabled/removed when users flag it for inappropriate content.", @"Requesting services is completely free. You can search and request any available services. Some servervice provider can travel to you!",  @"Please take the necessary precautions when meeting other people."];

    self.arrayImages = @[@"SvailLogo", @"checkmark", @"money", @"applePay", @"questionMark", @"cautionImage.jpg", @"requestService", @"cautionImage"];

    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.PageViewController.dataSource = self;

    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    // Change the size of page view controller
    self.PageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);

    [self addChildViewController:PageViewController];
    [self.view addSubview:PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];

}
- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender {

    UIStoryboard *mapStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mapTabVC = [mapStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarVC"];
    [self presentViewController:mapTabVC animated:true completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    if (index == [self.arrayPageFirstLabel count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.arrayPageFirstLabel count] == 0) || (index >= [self.arrayPageFirstLabel count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];

    pageContentViewController.textForLabel1 = self.arrayPageFirstLabel[index];
    pageContentViewController.textForLabel2 = self.arrayPageSecondLabel[index];
    pageContentViewController.imageFileName = self.arrayImages[index];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.arrayPageFirstLabel count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}



@end
