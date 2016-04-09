//
//  ParkingGarage.h
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/9/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkingUnits.h"

@interface ParkingGarage : NSObject

-(void) setupParkingGarage;

-(BOOL) garageExists;

-(NSDictionary *) noofOccupiedSpots;
-(NSDictionary *) noofUnoccupiedSpots;
-(void) bookSpotWithSpotNo:(int)spotNo withIdentifier:(NSString *)id;
-(NSDictionary *)reconfigureParkingSpotswithconfiguration:(NSDictionary *)configuration;
-(NSArray *) parkingSpotsWithType:(NSString *)type;
-(void) freeSpotWithSpotNo:(int)spotNo;
-(NSDictionary *) spotNoWithIdentifier:(NSString *)identifier;






@end
