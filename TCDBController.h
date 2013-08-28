//
//  TCDBController.h
//  TranslationCards
//
//  Created by Баз Светик on 28.08.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dictionaries.h"
#import "Profile.h"
#import "Words.h"
#import "Languages.h"

@interface TCDBController : NSObject

//управление профилем
- (void)addProfile:(NSString *)name;
- (void)delProfile:(Profile*)profile;
- (void)updateProfile:(Profile*)profile;
- (void)setCurrentProfile:(Profile*)profile;
- (void)setDefaultProfileSettings:(Profile*)profile;
- (NSArray*)getProfiles;

//управление словарями
- (void)addDictionary:(NSString*)name;
- (void)delDictionary:(Dictionaries*)dictionary;
- (void)updateDictionary:(Dictionaries*)dictionary;
- (void)setCurrentDictionary:(Dictionaries*)dictionary;
- (NSArray*)getDictionaries;

//управление перечнем языков
- (void)addLanguage:(NSString*)name;
- (void)delLanguage:(Languages*)language;
- (void)updateLanguage:(Languages*)language;
- (NSArray*)getLanguages;

//управление перечнем слов
- (void)addWord:(NSString*)word withTranslate:(NSString*)translate withOtherForms:(NSString*)form;
- (void)delWord:(Words*)word;
- (void)updateWord:(Words*)word;
- (NSArray*)getWords;

@end
