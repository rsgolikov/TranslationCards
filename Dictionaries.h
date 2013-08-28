//
//  Dictionaries.h
//  TranslationCards
//
//  Created by Баз Светик on 28.08.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Profile, Words;

@interface Dictionaries : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * id_translation_language;
@property (nonatomic, retain) NSNumber * id_original_language;
@property (nonatomic, retain) NSNumber * id_profile;
@property (nonatomic, retain) Profile *relationship;
@property (nonatomic, retain) Words *relationship1;

@end
