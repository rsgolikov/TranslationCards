//
//  Profile.h
//  TranslationCards
//
//  Created by Баз Светик on 28.08.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * id_global;
@property (nonatomic, retain) NSManagedObject *relationship;

@end
