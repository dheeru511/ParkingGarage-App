//
//  ParkingGarage.m
//  ParkingApp
//
//  Created by Dheeraj Singh on 9/9/15.
//  Copyright © 2015 Dheeraj Singh. All rights reserved.
//

#import "ParkingGarage.h"
#import "Constants.h"
#import "AppDelegate.h"


@interface ParkingGarage()

@property (nonatomic,strong) NSManagedObjectContext * context;
-(int)numberOfUnitsFromSpots:(NSDictionary *)spots;

@end

@implementation ParkingGarage


// Lazy instantiation of context object which is used throughout this class. The instance created in app delegate is used instaed of creating a new one
-(NSManagedObjectContext *)context
{
    if (!_context) {
        AppDelegate * applicationAppDelegae=[UIApplication sharedApplication].delegate;
        _context=applicationAppDelegae.managedObjectContext;
        return _context;
    }
    else
    {
        return _context;
    }
}

// setting up parking garage when app is loaded for first time
-(void) setupParkingGarage
{
  
    
    for (int i=1; i<=120; i++) {
        ParkingUnits * unit= [NSEntityDescription insertNewObjectForEntityForName:@"ParkingUnits"
                                                           inManagedObjectContext:self.context ];
        
        unit.unitNo=@(2*i-1);
        unit.spotNo=@(2*i-1);
        unit.isOccupied=[NSNumber numberWithBool:NO];
        unit.spotType=RegularType;
        
        ParkingUnits * unit1= [NSEntityDescription insertNewObjectForEntityForName:@"ParkingUnits"
                                                            inManagedObjectContext:self.context];
        
        unit1.unitNo=@(2*i);
        unit1.spotNo=@(2*i-1);;
        unit1.isOccupied=[NSNumber numberWithBool:NO];
        unit1.spotType=RegularType;
        
    }
    for (int i=121; i<=140; i++) {
        
        ParkingUnits * unit= [NSEntityDescription insertNewObjectForEntityForName:@"ParkingUnits"
                                                           inManagedObjectContext:self.context];
        
        unit.unitNo=@(240+ (i-120)*3-2);
        unit.spotNo=@(240+ (i-120)*3-2);
        unit.isOccupied=[NSNumber numberWithBool:NO];
        
        unit.spotType=HandicapType;
        
        ParkingUnits * unit1= [NSEntityDescription insertNewObjectForEntityForName:@"ParkingUnits"
                                                            inManagedObjectContext:self.context];
        
        unit1.unitNo=@(240+ (i-120)*3-1);
        unit1.spotNo=@(240+ (i-120)*3-2);
        unit1.isOccupied=[NSNumber numberWithBool:NO];
        
        unit1.spotType=HandicapType;
        
        
        ParkingUnits * unit2= [NSEntityDescription insertNewObjectForEntityForName:@"ParkingUnits"
                                                            inManagedObjectContext:self.context];
        
        unit2.unitNo=@(240+ (i-120)*3);
        unit2.spotNo=@(240+ (i-120)*3-2);
        unit2.isOccupied=[NSNumber numberWithBool:NO];
        
        unit2.spotType=HandicapType;
        
        
    }
    for (int i=141; i<=160; i++) {
        ParkingUnits * unit= [NSEntityDescription insertNewObjectForEntityForName:@"ParkingUnits"
                                                           inManagedObjectContext:self.context];
        
        unit.unitNo=@(120*2+20*3+(i-140));
        unit.spotNo=unit.unitNo;
        unit.isOccupied=[NSNumber numberWithBool:NO];
        
        unit.spotType=MotorcycleType;
        
        
    }
    NSError * error;
    [self.context save:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
}

// method to know if parking garage is already setup in the app

-(BOOL) garageExists
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ParkingUnits"];
    
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    
    return  [matches count] ? YES : NO;
    
}

// returns no of occupied spots

-(NSDictionary *) noofOccupiedSpots
{
    
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"ParkingUnits"];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"ParkingUnits"
                                              inManagedObjectContext:self.context];
    NSAttributeDescription* statusDesc = [entity.attributesByName objectForKey:@"spotType"];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath: @"spotNo"];
    NSExpression *countExpression = [NSExpression expressionForFunction: @"count:"
                                                              arguments: [NSArray arrayWithObject:keyPathExpression]];
    fetch.predicate=[NSPredicate predicateWithFormat:@"isOccupied== YES"];
    fetch.returnsDistinctResults=YES;
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName: @"count"];
    [expressionDescription setExpression: countExpression];
    [expressionDescription setExpressionResultType: NSInteger32AttributeType];
    
    [fetch setPropertiesToFetch:[NSArray arrayWithObjects:statusDesc, expressionDescription, nil]];
    [fetch setPropertiesToGroupBy:[NSArray arrayWithObject:statusDesc]];
    [fetch setResultType:NSDictionaryResultType];
    NSError* error = nil;
    NSArray *results = [self.context executeFetchRequest:fetch
                                                   error:&error];
    
    NSDictionary* occupiedUnits = [NSDictionary dictionaryWithObjects:[results valueForKey:@"count"]
                                                              forKeys:[results valueForKey:@"spotType"]];
    
    NSDictionary* occupiedSpots = @{ RegularType:@([[occupiedUnits valueForKey:RegularType] intValue]/2),HandicapType:@([[occupiedUnits valueForKey:HandicapType] intValue]/3),MotorcycleType:@([[occupiedUnits valueForKey:MotorcycleType] intValue]/1) };
    
    
    return occupiedSpots;
    
}

// returns no of unoccupied spots

-(NSDictionary *) noofUnoccupiedSpots
{
    
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"ParkingUnits"];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"ParkingUnits"
                                              inManagedObjectContext:self.context];
    NSAttributeDescription* statusDesc = [entity.attributesByName objectForKey:@"spotType"];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath: @"spotNo"];
    NSExpression *countExpression = [NSExpression expressionForFunction: @"count:"
                                                              arguments: [NSArray arrayWithObject:keyPathExpression]];
    fetch.predicate=[NSPredicate predicateWithFormat:@"isOccupied== NO "];
    fetch.returnsDistinctResults=YES;
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName: @"count"];
    [expressionDescription setExpression: countExpression];
    [expressionDescription setExpressionResultType: NSInteger32AttributeType];
    
    [fetch setPropertiesToFetch:[NSArray arrayWithObjects:statusDesc, expressionDescription, nil]];
    [fetch setPropertiesToGroupBy:[NSArray arrayWithObject:statusDesc]];
    [fetch setResultType:NSDictionaryResultType];
    NSError* error = nil;
    NSArray *results = [self.context executeFetchRequest:fetch
                                                   error:&error];
    
    NSDictionary* unOccupiedUnits = [NSDictionary dictionaryWithObjects:[results valueForKey:@"count"]
                                                                forKeys:[results valueForKey:@"spotType"]];
    
    NSDictionary* unOccupiedSpots = @{ RegularType:@([[unOccupiedUnits valueForKey:RegularType] intValue]/2),HandicapType:@([[unOccupiedUnits valueForKey:HandicapType] intValue]/3),MotorcycleType:@([[unOccupiedUnits valueForKey:MotorcycleType] intValue]/1) };
    
    
    return unOccupiedSpots;
    
}

// takes spot no and unique identifier and books spot

-(void) bookSpotWithSpotNo:(int)spotNo withIdentifier:(NSString *)id
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ParkingUnits" inManagedObjectContext:self.context];
    
    // Initialize Batch Update Request
    NSBatchUpdateRequest *batchUpdateRequest = [[NSBatchUpdateRequest alloc] initWithEntity:entityDescription];
    
    // Configure Batch Update Request
    [batchUpdateRequest setResultType:NSUpdatedObjectIDsResultType];
    [batchUpdateRequest setPropertiesToUpdate:@{ @"occupantsUniqueId" : id, @"isOccupied":@YES }];
    batchUpdateRequest.predicate=[NSPredicate predicateWithFormat:@"spotNo=%d",spotNo];
    
    // Execute Batch Request
    NSError *batchUpdateRequestError = nil;
    NSBatchUpdateResult *batchUpdateResult = (NSBatchUpdateResult *)[self.context executeRequest:batchUpdateRequest error:&batchUpdateRequestError];
    if(batchUpdateRequestError)
    {
        NSLog(@"%@",batchUpdateResult);
    }
//    NSError * error;
//    [self.context save:&error];
}

// takes spot no and frees spot

-(void) freeSpotWithSpotNo:(int)spotNo
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ParkingUnits" inManagedObjectContext:self.context];
    
    // Initialize Batch Update Request
    NSBatchUpdateRequest *batchUpdateRequest = [[NSBatchUpdateRequest alloc] initWithEntity:entityDescription];
    
    // Configure Batch Update Request
    [batchUpdateRequest setResultType:NSUpdatedObjectIDsResultType];
    [batchUpdateRequest setPropertiesToUpdate:@{ @"occupantsUniqueId" : @"", @"isOccupied":@NO }];
    batchUpdateRequest.predicate=[NSPredicate predicateWithFormat:@"spotNo=%d",spotNo];
    
    // Execute Batch Request
    NSError *batchUpdateRequestError = nil;
    NSBatchUpdateResult *batchUpdateResult = (NSBatchUpdateResult *)[self.context executeRequest:batchUpdateRequest error:&batchUpdateRequestError];
    if(batchUpdateRequestError)
    {
        NSLog(@"%@",batchUpdateResult);
    }
    NSError * error;
    [self.context save:&error];
}

// returns spotNo for given identifier

-(NSDictionary *) spotNoWithIdentifier:(NSString *)identifier
{
     NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ParkingUnits"];
    request.predicate = [NSPredicate predicateWithFormat:@"occupantsUniqueId=%@",identifier];
    request.returnsDistinctResults=YES;
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"spotNo",@"spotType",nil]];
    NSError * error;
    NSArray * result =[self.context executeFetchRequest:request error:&error];
    if (![result count] || !result || [result count]>1) {
        return nil;
    }
    else
    {
        NSNumber * spotNo=[[result firstObject] objectForKey:@"spotNo"];
        NSString * spotType=[[result firstObject] objectForKey:@"spotType"];
        NSDictionary * dict=@{@"spotNo":spotNo,@"spotType":spotType};
        return dict;
    }
}

// helper method. Takes no of spots and returns no of units
-(int)numberOfUnitsFromSpots:(NSDictionary *)spots
{
    
    int  units= [(NSNumber *)[spots objectForKey:RegularType] intValue]*2 +[(NSNumber *)[spots objectForKey:HandicapType] intValue]*3+[(NSNumber *)[spots objectForKey:MotorcycleType] intValue] ;
    return units;
}

// returns spot nos and occupied status based on the parking spot type(regular/motorcycle/handicap)
-(NSArray *) parkingSpotsWithType:(NSString *)type
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ParkingUnits"];
    request.predicate = [NSPredicate predicateWithFormat:@"spotType=%@",type];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"spotNo", @"isOccupied",nil]];

    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"spotNo" ascending:YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    request.returnsDistinctResults=YES;
    NSError * error;
    NSArray * parkingSpots =[self.context executeFetchRequest:request error:&error];
//    NSMutableArray * parkingSpots = [parkingSpotsDict valueForKey:@"spotNo"];
    return parkingSpots;
    
}



// takes new configuaration as input, evaluates if new combination is possible and reconfigures parking spot
-(NSDictionary *)reconfigureParkingSpotswithconfiguration:(NSDictionary *)configuration
{
    
    int totalAvailableUnits= [self numberOfUnitsFromSpots:self.noofUnoccupiedSpots];
    NSDictionary * occupiedSpots =[self noofOccupiedSpots];
    int  requiredRegularUnits;
    int  requiredHandicapUnits;
    int  requiredMotorcycleUnits;
    NSDictionary * newConfiguration;
    
    
    // this if else block computes if the new configuration is feasible .if input has only no of spots for 2 parking types, it deduces no of spots for 3rd parking type and if it is not feasible it returns a dictionary with key value "possible: no" .
    
    if ([configuration count]==3) {
        
        requiredRegularUnits=([[configuration objectForKey:RegularType] intValue]-[[occupiedSpots objectForKey:RegularType] intValue])*2;
        requiredHandicapUnits=([[configuration objectForKey:HandicapType] intValue]-[[occupiedSpots objectForKey:HandicapType] intValue])*3;
        requiredMotorcycleUnits=[[configuration objectForKey:MotorcycleType] intValue]-[[occupiedSpots objectForKey:MotorcycleType] intValue];
        int requiredUnits=requiredRegularUnits+requiredHandicapUnits+requiredMotorcycleUnits;
        if (requiredUnits!=totalAvailableUnits || requiredMotorcycleUnits<0 || requiredHandicapUnits<0 || requiredRegularUnits<0) {
            return @{@"possible":@"NO"};
        }
        newConfiguration=configuration;
    }
    else if (![configuration objectForKey:RegularType])
    {
        requiredHandicapUnits=([[configuration objectForKey:HandicapType] intValue]-[[occupiedSpots objectForKey:HandicapType] intValue])*3;
        requiredMotorcycleUnits=[[configuration objectForKey:MotorcycleType] intValue]-[[occupiedSpots objectForKey:MotorcycleType] intValue];
        int remainingUnits=totalAvailableUnits- (requiredHandicapUnits+requiredMotorcycleUnits);
        if (remainingUnits%2==0 && remainingUnits>=0 && requiredHandicapUnits>=0 && requiredMotorcycleUnits>=0) {
            requiredRegularUnits=remainingUnits;
        }
        else{
            return @{@"possible":@"NO"};
        }
        
        newConfiguration =@{MotorcycleType: [configuration objectForKey:MotorcycleType],HandicapType:[configuration objectForKey:HandicapType],RegularType: @((320-([[configuration objectForKey:MotorcycleType] intValue]+[[configuration objectForKey:HandicapType] intValue]*3))/2) };
        
        
    }
    else if (![configuration objectForKey:HandicapType])
    {
        requiredRegularUnits=([[configuration objectForKey:RegularType] intValue]-[[occupiedSpots objectForKey:RegularType] intValue])*2;
        requiredMotorcycleUnits=[[configuration objectForKey:MotorcycleType] intValue]-[[occupiedSpots objectForKey:MotorcycleType] intValue];
        int remainingUnits=totalAvailableUnits- (requiredRegularUnits+requiredMotorcycleUnits);
        if (remainingUnits%3==0 && remainingUnits>=0 && requiredMotorcycleUnits>=0 && requiredRegularUnits>=0) {
            requiredHandicapUnits=remainingUnits;
        }
        else{
            return @{@"possible":@"NO"};
        }
        newConfiguration =@{MotorcycleType: [configuration objectForKey:MotorcycleType],RegularType:[configuration objectForKey:RegularType],HandicapType: @((320-([[configuration objectForKey:RegularType] intValue]*2+[[configuration objectForKey:MotorcycleType] intValue]))/3) };
    }
    else{
        requiredRegularUnits=([[configuration objectForKey:RegularType] intValue]-[[occupiedSpots objectForKey:RegularType] intValue])*2;
        requiredHandicapUnits=([[configuration objectForKey:HandicapType] intValue]-[[occupiedSpots objectForKey:HandicapType] intValue])*3;
        int remainingUnits=totalAvailableUnits- (requiredRegularUnits +requiredHandicapUnits);
        if (remainingUnits>=0 && requiredRegularUnits>=0 && requiredHandicapUnits>=0) {
            requiredMotorcycleUnits=remainingUnits;
        }
        else{
            return @{@"possible":@"NO"};
        }
        
        newConfiguration =@{RegularType: [configuration objectForKey:RegularType],HandicapType:[configuration objectForKey:HandicapType],MotorcycleType: @((320-([[configuration objectForKey:RegularType] intValue]*2+[[configuration objectForKey:HandicapType] intValue]*3))/3) };
    }
    
    //if new combination is feasible, parking spots are configured based on new configuration
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ParkingUnits"];
    request.predicate = [NSPredicate predicateWithFormat:@"isOccupied== NO"];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"unitNo" ascending:YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    NSError * error;
    NSArray * availableUnitObjects=[self.context executeFetchRequest:request error:&error];
    //    int count =1;
    NSNumber * spot;
    for (int i=0; i<requiredRegularUnits; i++) {
        ParkingUnits * unit= (ParkingUnits *)availableUnitObjects[i];
        
        if (i%2==0) {
            spot=unit.unitNo;
        }
        unit.spotNo=spot;
        unit.spotType=RegularType;
        
    }
    spot=0;
    for (int i=0; i<requiredHandicapUnits; i++) {
        ParkingUnits * unit= (ParkingUnits *)availableUnitObjects[i+requiredRegularUnits];
        
        if (i%3==0) {
            spot=unit.unitNo;
        }
        unit.spotNo=spot;
        unit.spotType=HandicapType;
        
    }
    spot=0;
    
    for (int i=0; i<requiredMotorcycleUnits; i++) {
        ParkingUnits * unit= (ParkingUnits *)availableUnitObjects[i+requiredRegularUnits+requiredHandicapUnits];
        
        unit.spotNo=unit.unitNo;
        unit.spotType=MotorcycleType;
        
    }
    [self.context save:nil];
    
    
    return newConfiguration;
    
    
}


@end
