//
//  DetailsVC.h
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/9/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsVC : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong) NSString * title1;
@property (strong,nonatomic) NSString * identifier;
@end
