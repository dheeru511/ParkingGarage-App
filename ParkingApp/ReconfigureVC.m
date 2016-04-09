//
//  ReconfigureVC.m
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/10/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//

#import "ReconfigureVC.h"
#import "ParkingGarage.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface ReconfigureVC ()
@property (weak, nonatomic) IBOutlet UITextField *regularSpots;
@property (weak, nonatomic) IBOutlet UITextField *handicapSpots;
@property (weak, nonatomic) IBOutlet UITextField *motorCycleSpots;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;
@property (strong,nonatomic) NSDictionary * Configuration;
@property (strong, nonatomic) ParkingGarage * parkingGarage;

@end

@implementation ReconfigureVC

# pragma mark viewcontoller life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate * applicationAppDelegae=[UIApplication sharedApplication].delegate;
    self.parkingGarage=applicationAppDelegae.parkingGarage;
    [self.navigation.leftBarButtonItem setEnabled:NO];

    // Do any additional setup after loading the view.
}

# pragma mark UItextfield protocol methods
-(void)textFieldDidBeginEditing:(nonnull UITextField *)textField
{
    [self.navigation.leftBarButtonItem setEnabled:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}



// method called when cancel is clicked
- (IBAction)Cancel:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)postAlertWithMessage:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* disallow = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         
                                                         
                                                         
                                                     }];
    [alert addAction:disallow];
    [self presentViewController:alert animated:YES completion:nil];
}
// in this method, decision is taken whether to perform segue when clicked on done. it validates if atleast 2 spot types are entered and whether it is a valid combination
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
    
    
    if ([self.regularSpots.text length] && [self.handicapSpots.text length] && [self.motorCycleSpots.text length]) {
        self.Configuration=@{RegularType:self.regularSpots.text,HandicapType:self.handicapSpots.text,MotorcycleType:self.motorCycleSpots.text};
        NSDictionary * newConfiguration=[self.parkingGarage reconfigureParkingSpotswithconfiguration:self.Configuration];
        if (![newConfiguration objectForKey:@"possible"]) {
            return YES;
        }
        else
        {
            [self postAlertWithMessage:@"This Configuration is not possible with available spots"];
            return NO;
            
        }
    }
    else if (![self.regularSpots.text length] && [self.handicapSpots.text length] && [self.motorCycleSpots.text length])
    {
        self.Configuration=@{HandicapType:self.handicapSpots.text,MotorcycleType:self.motorCycleSpots.text};
        NSDictionary * newConfiguration=[self.parkingGarage reconfigureParkingSpotswithconfiguration:self.Configuration];
        if (![newConfiguration objectForKey:@"possible"]) {
            return YES;
        }
        else
        {
            [self postAlertWithMessage:@"This Configuration is not possible with available spots"];
            return NO;
        }
        
    }
    else if ([self.regularSpots.text length] && ![self.handicapSpots.text length] && [self.motorCycleSpots.text length])
    {
        self.Configuration=@{RegularType:self.regularSpots.text,MotorcycleType:self.motorCycleSpots.text};
        NSDictionary * newConfiguration=[self.parkingGarage reconfigureParkingSpotswithconfiguration:self.Configuration];
        if (![newConfiguration objectForKey:@"possible"]) {
            return YES;
        }
        else
        {
            [self postAlertWithMessage:@"This Configuration is not possible with available spots"];
            return NO;
            
        }
        
    }
    else if ([self.regularSpots.text length] && [self.handicapSpots.text length] && ![self.motorCycleSpots.text length])
    {
        self.Configuration=@{RegularType:self.regularSpots.text,HandicapType:self.handicapSpots.text};
        NSDictionary * newConfiguration=[self.parkingGarage reconfigureParkingSpotswithconfiguration:self.Configuration];
        if (![newConfiguration objectForKey:@"possible"]) {
            return YES;
        }
        else
        {
            [self postAlertWithMessage:@"This Configuration is not possible with available spots"];
            return NO;
            
        }
        
    }
    else
    {
        [self postAlertWithMessage:@"Enter values for atleast 2 spot types"];
        return NO;
    }
}

@end
