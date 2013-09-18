//
//  TCProfileModel.m
//  TranslationCards
//
//  Created by Баз Светик on 02.09.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import "TCProfileModel.h"
#import "TCDictionariesModel.h"


@implementation TCProfileModel

-(void)setIsCurrent:(NSNumber *)isCurrent {
  if (self.isCurrent == isCurrent) {
    return;
  };

  _isCurrent = isCurrent;

  if (isCurrent == [NSNumber numberWithBool:true]) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profiles" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isCurrent = 1"];
    [request setPredicate:pred];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (NSManagedObject *obj in mutableFetchResults) {
      if (obj != self) {
        [obj setValue:@"0" forKey:@"isCurrent"];
      }
    }
  }
}

@synthesize isCurrent = _isCurrent;
@dynamic name;
@dynamic dictionaries;

@end
