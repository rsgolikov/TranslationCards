//
//  TCDictionariesModel.h
//  TranslationCards
//
//  Created by user6230 on 8/29/13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TCLanguagesModel, TCProfileModel, TCWordsModel;

@interface TCDictionariesModel : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * id_original_language;
@property (nonatomic, retain) NSNumber * id_profile;
@property (nonatomic, retain) NSNumber * id_translation_language;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) TCProfileModel *profile;
@property (nonatomic, retain) TCLanguagesModel *translationLanguage;
@property (nonatomic, retain) TCLanguagesModel *originalLanguage;
@property (nonatomic, retain) TCWordsModel *words;

@end
