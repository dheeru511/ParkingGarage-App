//
//  ViewController.m
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/9/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//

#import "HomeViewController.h"
#import "ParkingGarage.h"
#import "ParkingSpotsVC.h"
#import "AppDelegate.h"


@interface HomeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *regularSpots;
@property (weak, nonatomic) IBOutlet UIButton *handicapSpots;
@property (weak, nonatomic) IBOutlet UIButton *motorcycleSpots;
@property (weak, nonatomic) IBOutlet UITextField *uniqueIdentifier;
@property (strong,nonatomic) NSDictionary * spotInfo;
@property (strong,nonatomic) ParkingGarage * parkingGarage;
@end

@implementation HomeViewController



# pragma mark viewcontoller life cycle methods


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor=self.view.backgroundColor;
    AppDelegate * applicationAppDelegae=[UIApplication sharedApplication].delegate;
    self.parkingGarage=applicationAppDelegae.parkingGarage;
}


// everytime we return back to home page after booking spots,reconfiguring, we need the button to have updated spots information. So calling it in view will appear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self updateSpotInfo];
}
//want to remove keyboard when leaving this viewcontroller
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.uniqueIdentifier resignFirstResponder];
}


# pragma mark UItextfield protocol methods

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}


#pragma mark segue and other helper methods

// method to update UI buttons with new available spots information

-(void)updateSpotInfo
{
    NSDictionary * occupiedSpots= [self.parkingGarage noofOccupiedSpots];
    NSDictionary * unOccupiedSpots=[self.parkingGarage noofUnoccupiedSpots];
    
    self.regularSpots.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.regularSpots.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString * x=@"Regular Spots\n";
    NSString * y=[NSString stringWithFormat:@"Total:%d Availbale:%d",[[occupiedSpots objectForKey:RegularType] intValue] +[[unOccupiedSpots objectForKey:RegularType ] intValue],[[unOccupiedSpots objectForKey:RegularType ] intValue]];
    NSString * z=[x stringByAppendingString:y];
    [self.regularSpots setTitle: z forState: UIControlStateNormal];
    
    self.handicapSpots.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.handicapSpots.titleLabel.textAlignment = NSTextAlignmentCenter;
    x=@"Handicap Spots\n";
    y=[NSString stringWithFormat:@"Total:%d Availbale:%d",[[occupiedSpots objectForKey:HandicapType] intValue] +[[unOccupiedSpots objectForKey:HandicapType ] intValue],[[unOccupiedSpots objectForKey:HandicapType ] intValue]];
    z=[x stringByAppendingString:y];
    [self.handicapSpots setTitle: z forState: UIControlStateNormal];
    
    self.motorcycleSpots.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.motorcycleSpots.titleLabel.textAlignment = NSTextAlignmentCenter;
    x=@"Motorcycle Spots\n";
    y=[NSString stringWithFormat:@"Total:%d Availbale:%d",[[occupiedSpots objectForKey:MotorcycleType] intValue] +[[unOccupiedSpots objectForKey:MotorcycleType ] intValue],[[unOccupiedSpots objectForKey:MotorcycleType ] intValue]];
    z=[x stringByAppendingString:y];
    [self.motorcycleSpots setTitle: z forState: UIControlStateNormal];

}

// segue to parkingspots viewcontroller

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    if ([segue.identifier isEqualToString:@"ShowRegularSpots"]) {
        ParkingSpotsVC * vc=(ParkingSpotsVC *)segue.destinationViewController;
        vc.title=@"Regular Parking Spots";
        vc.parkingType=RegularType;
    }
    
    if ([segue.identifier isEqualToString:@"ShowHandicapSpots"]) {
        ParkingSpotsVC * vc=(ParkingSpotsVC *)segue.destinationViewController;
        vc.title=@"Handicap Parking Spots";
        vc.parkingType=HandicapType;
    }
    if ([segue.identifier isEqualToString:@"ShowMotorcycleSpots"]) {
        ParkingSpotsVC * vc=(ParkingSpotsVC *)segue.destinationViewController;
        vc.title=@"Motorcycle Parking Spots";
        vc.parkingType=MotorcycleType;

    }
    
    // segue when user searchs for a spot corresponding to a drive lisence no
    
    if ([segue.identifier isEqualToString:@"ShowSearchedSpot"]) {
        ParkingSpotsVC * vc=(ParkingSpotsVC *)segue.destinationViewController;
        NSString * spotType=[self.spotInfo objectForKey:@"spotType"];
        vc.title=[NSString stringWithFormat:@"%@ Parking Spots",spotType] ;
        vc.spotNo=[self.spotInfo objectForKey:@"spotNo"];
        if ([spotType isEqualToString:@"regular"]) {
            vc.parkingType=RegularType;
            
        }
        else if ([spotType isEqualToString:@"handicap"]){
            vc.parkingType=HandicapType;
        }else{
            vc.parkingType=MotorcycleType;
        }
        
        
    }
    
}

// method called from reconfigure view controller durinf unwind segue. Nothing to implement here as no data requires to be captured from that view controller before unwinding

-(IBAction)reconfigure:(UIStoryboardSegue *)segue
{
    
}

// this method takes decision whether to seque to parking spots based on the value lisence no entered in search box. for ex if there is no spot corresponding to lisence no then dont segue
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowSearchedSpot"]) {
        if (![self.uniqueIdentifier.text length])
        {
            [self postAlertWithMessage:@"Driver Lisence can't be empty"];
            
            return NO;
        }
        else
        {
           self.spotInfo= [self.parkingGarage spotNoWithIdentifier:self.uniqueIdentifier.text];
            
            if (self.spotInfo) {
                return YES;
            }else{
                [self postAlertWithMessage:@"No Spot is booked with this Driver Lisence No"];
                return NO;
            }
        }
    }
    return YES;
    
}





// helper method. displays popup on UI with provided message
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

// to dismiss keyboard when tapped on view
- (IBAction)tapped:(UITapGestureRecognizer *)sender {
    [self.uniqueIdentifier resignFirstResponder];
}


@end
