//
//  TCDictionariesModel.h
//  TranslationCards
//
//  Created by Баз Светик on 02.09.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TCLanguagesModel, TCProfileModel, TCWordsModel;

@interface TCDictionariesModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) TCLanguagesModel *originalLanguage;
@property (nonatomic, retain) TCProfileModel *profile;
@property (nonatomic, retain) TCLanguagesModel *translationLanguage;
@property (nonatomic, retain) NSSet *words;
@end

@interface TCDictionariesModel (CoreDataGeneratedAccessors)

- (void)addWordsObject:(TCWordsModel *)value;
- (void)removeWordsObject:(TCWordsModel *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

@end
