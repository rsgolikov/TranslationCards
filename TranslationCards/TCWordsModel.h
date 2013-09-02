//
//  TCWordsModel.h
//  TranslationCards
//
//  Created by Баз Светик on 02.09.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TCDictionariesModel;

@interface TCWordsModel : NSManagedObject

@property (nonatomic, retain) NSNumber * countShows;
@property (nonatomic, retain) NSNumber * isMastered;
@property (nonatomic, retain) NSString * otherForms;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) TCDictionariesModel *dictionary;

@end
