//
//  TCDBController.m
//  TranslationCards
//
//  Created by Баз Светик on 28.08.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import "TCDBController.h"

@implementation TCDBController

//управление профилем
- (void)addProfile:(NSString *)name{
    
}
- (void)delProfile:(Profile*)profile{
    
}
- (void)updateProfile:(Profile*)profile{
    
}
- (void)setCurrentProfile:(Profile*)profile;{
    
}
- (void)setDefaultProfileSettings:(Profile*)profile{
    
}
- (NSArray*)getProfiles{
    NSArray *dummy = [[NSArray alloc] initWithObjects:@"getProfiles", nil];
    return dummy;
}

//управление словарями
- (void)addDictionary:(NSString*)name{
    
}
- (void)delDictionary:(Dictionaries*)dictionary{
    
}
- (void)updateDictionary:(Dictionaries*)dictionary{
    
}
- (void)setCurrentDictionary:(Dictionaries*)dictionary{
    
}
- (NSArray*)getDictionaries{
    NSArray *dummy = [[NSArray alloc] initWithObjects:@"getDictionaries", nil];
    return dummy;
}

//управление перечнем языков
- (void)addLanguage:(NSString*)name{
    
}
- (void)delLanguage:(Languages*)language{
    
}
- (void)updateLanguage:(Languages*)language{
    
}
- (NSArray*)getLanguages{
    NSArray *dummy = [[NSArray alloc] initWithObjects:@"getLanguages", nil];
    return dummy;
}

//управление перечнем слов
- (void)addWord:(NSString*)word withTranslate:(NSString*)translate withOtherForms:(NSString*)form{
    
}
- (void)delWord:(Words*)word{
    
}
- (void)updateWord:(Words*)word{
    
}
- (NSArray*)getWords{
    NSArray *dummy = [[NSArray alloc] initWithObjects:@"getWords", nil];
    return dummy;
}


@end
