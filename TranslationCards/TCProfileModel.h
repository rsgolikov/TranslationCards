//
//  TCProfileModel.h
//  TranslationCards
//
//  Created by user6230 on 8/29/13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TCDictionariesModel;

@interface TCProfileModel : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * id_global;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *dictionaries;
@end

@interface TCProfileModel (CoreDataGeneratedAccessors)

- (void)addDictionariesObject:(TCDictionariesModel *)value;
- (void)removeDictionariesObject:(TCDictionariesModel *)value;
- (void)addDictionaries:(NSSet *)values;
- (void)removeDictionaries:(NSSet *)values;

@end
