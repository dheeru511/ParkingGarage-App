//
//  ParkingUnits.h
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/9/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParkingUnits : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nullable, nonatomic, retain) NSNumber *isOccupied;
@property (nullable, nonatomic, retain) NSString *occupantsUniqueId;
@property (nullable, nonatomic, retain) NSNumber *spotNo;
@property (nullable, nonatomic, retain) NSString *spotType;
@property (nullable, nonatomic, retain) NSNumber *unitNo;
@end

NS_ASSUME_NONNULL_END

