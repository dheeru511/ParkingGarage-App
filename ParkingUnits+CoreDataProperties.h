//
//  ParkingUnits+CoreDataProperties.h
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/9/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "ParkingUnits.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParkingUnits (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isOccupied;
@property (nullable, nonatomic, retain) NSString *occupantsUniqueId;
@property (nullable, nonatomic, retain) NSNumber *spotNo;
@property (nullable, nonatomic, retain) NSString *spotType;
@property (nullable, nonatomic, retain) NSNumber *unitNo;

@end

NS_ASSUME_NONNULL_END
