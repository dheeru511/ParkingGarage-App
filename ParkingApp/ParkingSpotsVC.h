//
//  ParkingSpotsVC.h
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/9/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingSpotsVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@ property (strong,nonatomic) NSString * parkingType;
@ property (strong,nonatomic) NSNumber * spotNo;

@end
