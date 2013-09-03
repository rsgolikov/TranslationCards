//
//  TCLanguagesModel.h
//  TranslationCards
//
//  Created by Баз Светик on 02.09.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TCDictionariesModel;

@interface TCLanguagesModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *dcitionaryorigin;
@property (nonatomic, retain) NSSet *dictionarytranslate;
@end

@interface TCLanguagesModel (CoreDataGeneratedAccessors)

- (void)addDcitionaryoriginObject:(TCDictionariesModel *)value;
- (void)removeDcitionaryoriginObject:(TCDictionariesModel *)value;
- (void)addDcitionaryorigin:(NSSet *)values;
- (void)removeDcitionaryorigin:(NSSet *)values;

- (void)addDictionarytranslateObject:(TCDictionariesModel *)value;
- (void)removeDictionarytranslateObject:(TCDictionariesModel *)value;
- (void)addDictionarytranslate:(NSSet *)values;
- (void)removeDictionarytranslate:(NSSet *)values;

@end
