//
//  DetailsVC.m
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/9/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//

#import "DetailsVC.h"

@interface DetailsVC ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;
@property (weak, nonatomic) IBOutlet UITextField *txtField;

@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigation.title=[NSString stringWithFormat:@"SPOT NO:%@",self.title1];
    [self.navigation.leftBarButtonItem setEnabled:NO];
    
}



# pragma mark UItextfield protocol methods

// enabling done button only when user starts entering some text in the text field

-(void)textFieldDidBeginEditing:(nonnull UITextField *)textField
{
    [self.navigation.leftBarButtonItem setEnabled:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

// method called when user clicks on cancel button

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// segue back to parkingspots view controller
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
    if ([identifier isEqualToString:@"BookSpot"]) {
        if (![self.txtField.text length])
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                           message:@"Unique Identifier cannot be empty"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* disallow = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                                 
                                                                 
                                                                 
                                                             }];
            [alert addAction:disallow];
            [self presentViewController:alert animated:YES completion:nil];
            
            return NO;
        }
        else
        {
            self.identifier=self.txtField.text;
            return YES;
        }
    }
    return NO;
    
}



@end
