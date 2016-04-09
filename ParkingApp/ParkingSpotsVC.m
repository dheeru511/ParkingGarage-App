//
//  ParkingSpotsVC.m
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/9/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//

#import "ParkingSpotsVC.h"
#import "ParkingGarage.h"
#import "DetailsVC.h"
#import "AppDelegate.h"

@interface ParkingSpotsVC()


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) ParkingGarage * parkingGarage;
@property (strong,nonatomic) NSArray * parkingSpots;
@property (strong,nonatomic) NSIndexPath * spotIndex;

@end

@implementation ParkingSpotsVC




-(void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate * applicationAppDelegae=[UIApplication sharedApplication].delegate;
    self.parkingGarage=applicationAppDelegae.parkingGarage;
    self.parkingSpots=[self.parkingGarage parkingSpotsWithType:self.parkingType];
    
    // if spotNo property is not nill, this view controller is loaded due to search action, hence index path for spot no is calculated and while laoding collection view is scrolled to that particular spotno and is highlighted
    
    if (self.spotNo) {
        self.spotIndex=  [self indexPathForSpot:self.spotNo];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
  // if spotNo property is not nill, this view controller is loaded due to search action, hence index path for spot no is calculated and while laoding collection view is scrolled to that particular spotno and is highlighted
    if (self.spotNo) {
        [self.collectionView scrollToItemAtIndexPath:self.spotIndex atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }
    
   
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.spotNo=nil;
}

// helper method. fetches the latest data from coredata tables and loads table view.this method is called when returning to collection view after booking a spot or free spot. the latest spot booked, freed should be shown booked/free accordingly
-(void)updateCollectionView
{
    
    self.parkingSpots=[self.parkingGarage parkingSpotsWithType:self.parkingType];
    [self.collectionView reloadData];
}

//method to know the indexpath of the spot no the user searched for
-(NSIndexPath *)indexPathForSpot:(NSNumber *)spotNo
{
    NSIndexPath * index;
    for (int i=0; i<[self.parkingSpots count]; i++) {
        if ([[self.parkingSpots[i] objectForKey:@"spotNo"] isEqual:self.spotNo]) {
            index= [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    return index;
}


#pragma mark Collection View delegate Methods

-(NSInteger)numberOfSectionsInCollectionView:(nonnull UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.parkingSpots count];
}

-(UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    
    // while returning viewcells, color is set based on if they are occupied. Also they are highlighted if user serached for that spot No
    
    UICollectionViewCell * cell=[self.collectionView dequeueReusableCellWithReuseIdentifier:@"Spot" forIndexPath:indexPath ];
    UILabel * label=(UILabel *)[cell viewWithTag:100];
    label.text=[[self.parkingSpots[indexPath.row] objectForKey:@"spotNo"] stringValue];
    if ([(NSNumber *)[self.parkingSpots[indexPath.row] objectForKey:@"isOccupied"] isEqual:@1] ) {
        cell.backgroundColor=[UIColor blueColor];
        label.textColor=[UIColor whiteColor];
        cell.layer.borderWidth=5.0f;
        cell.layer.borderColor=[UIColor blueColor].CGColor;
        if (self.spotNo) {
            if ([self.spotIndex isEqual:indexPath]) {
                cell.layer.borderWidth=5.0f;
                cell.layer.borderColor=[UIColor redColor].CGColor;
            }else{
                cell.layer.borderWidth=5.0f;
                cell.layer.borderColor=[UIColor blueColor].CGColor;
            }
        }
    }
    else
    {
        cell.backgroundColor=[UIColor whiteColor];
        label.textColor=[UIColor blueColor];
        cell.layer.borderWidth=5.0f;
        cell.layer.borderColor=[UIColor whiteColor].CGColor;

    }
  
    return cell;
}

// segue to details viewcontroller to capture unique id
- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender
{
    
    
    if ([segue.identifier isEqualToString:@"CaptureUniqueID"]) {
        DetailsVC * vc=(DetailsVC *)segue.destinationViewController;
        
        vc.title1=[NSString stringWithFormat:@"%@",[self.parkingSpots[[sender intValue]] objectForKey:@"spotNo"]];
    }
    
   
}
// when user selects a parking spot, UIAlertcontroller appears with branching decisions
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSNumber * row= [[NSNumber alloc] initWithInteger: indexPath.row];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"SPOT NO: %@",[[self.parkingSpots[indexPath.row] objectForKey:@"spotNo"] stringValue]]
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* book = [UIAlertAction actionWithTitle:@"Book Spot" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              
                                                              [self performSegueWithIdentifier:@"CaptureUniqueID" sender:row];
                                                            
                                                          }];
    UIAlertAction* free = [UIAlertAction actionWithTitle:@"Free Spot" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.parkingGarage freeSpotWithSpotNo:[[self.parkingSpots[indexPath.row] objectForKey:@"spotNo"] intValue]];
                                                              [self updateCollectionView];
                                                              
                                                          }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {}];
    
    [alert addAction:book];
    [alert addAction:free];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}

// method called from details view controller during unwind segue

-(IBAction)bookSpot:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"BookSpot"]) {
        
        DetailsVC * vc=(DetailsVC *)segue.sourceViewController;
        NSString * identifier= vc.identifier;
        NSString * spotNo=vc.title1;
        [self.parkingGarage bookSpotWithSpotNo:[spotNo intValue] withIdentifier:identifier];
        [self updateCollectionView];
    }
    
    
}


@end
