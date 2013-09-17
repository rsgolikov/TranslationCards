//
//  TCDBController.m
//  TranslationCards
//
//  Created by Баз Светик on 28.08.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import "TCDBController.h"
//#import <CoreData/CoreData.h>

@implementation TCDBController
@synthesize currentProfile = _currentProfile;
@synthesize currentDictionary = _currentDictionary;


//обработчики ошибки не реализовываем нигде,соответственно и логику при возникновении ошибки тоже, если надо будет позже...


//при создании класса необходимо инициализировать переменные current
- (id)init
{
    self = [super init];
    if (self) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profiles" inManagedObjectContext:[self managedObjectContext]];
        [request setEntity:entity];
        NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"isCurrent == %@", [NSNumber numberWithBool: YES]];
        [request setPredicate:fetchPredicate];
        NSError *error = nil;
        _currentProfile = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
        NSLog(@"Current profile: %@", _currentProfile.name);
        entity = nil;
        fetchPredicate = nil;
        entity = [NSEntityDescription entityForName:@"Dictionaries" inManagedObjectContext:[self managedObjectContext]];
        [request setEntity:entity];
        fetchPredicate = [NSPredicate predicateWithFormat:@"profile == %@", _currentProfile];
        [request setPredicate:fetchPredicate];
        error = nil;
        //последний словарь текущим..
        _currentDictionary = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
        NSLog(@"Current dictionary: %@", _currentDictionary.name);
     }
    return self;
}

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"TCData.xcdatamodeld"]];
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle the error.
    }
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

//управление профилем
//однинаковые имена = один профиль. соответственно при добавлении имени проверяем на наличие и выдаем или профиль или nil 
- (TCProfileModel*)getProfileWithName:(NSString *)name{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profiles" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@ ", name];
    [request setPredicate:pred];
    NSError *error = nil;
    TCProfileModel *fetchResult = nil;
    fetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    return fetchResult;
}
//собственно добавление профиля
- (void)addProfile:(NSString *)name{
    TCProfileModel *profile=[self getProfileWithName:name];
    if (profile==nil){
        TCProfileModel *tcpfm = (TCProfileModel*)[NSEntityDescription insertNewObjectForEntityForName:@"Profiles" inManagedObjectContext:[self managedObjectContext]];
        [tcpfm setName:name];
        [tcpfm setIsCurrent:[NSNumber numberWithBool:true]];
        _currentProfile = tcpfm;
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
            NSLog(@"Profile add error: %@", error);
        }
        NSLog(@"Profile add: %@", name);
    } else {
        NSLog(@"Profile name %@ found one", name);
    }
}

- (void)delProfile:(TCProfileModel*)profile{
    //переделать на уделение по имени
    [[self managedObjectContext] deleteObject:profile];
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }

}

- (void)updateProfile:(TCProfileModel*)profile{
    //обновление только текущего профиля или нужно передавать два профиля в процедуру/ не нужно только текущего/
    if (_currentProfile == nil) return;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profiles"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self == %@", _currentProfile];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) { //it's true always
        for (NSManagedObject *obj in array) {
               [obj setValue:profile.name forKey:@"name"];
        }
    }
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}

- (void)setCurrentProfile:(TCProfileModel*)profile;{
    //выбранный в списке профайлов профайл сделать текущим
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profiles"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    //для профиля нам по сути нужно только имя но можно и объект
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self == %@", profile];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) { //it's true always
        for (NSManagedObject *obj in array) {
            //интересно сработает сбос признака у остальных в классе профиля?
            [obj setValue:[NSNumber numberWithBool:true] forKey:@"setIsCurrent"];
        }
        _currentProfile = profile;
    }
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}

- (NSArray*)getProfiles{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profiles" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    NSLog(@"Profile count: %d", mutableFetchResults.count);
    return mutableFetchResults;
    //[[NSArray alloc] initWithArray:mutableFetchResults copyItems:TRUE];
    mutableFetchResults = nil;
}

//управление словарями

- (TCDictionariesModel*)getDictionaryWithName:(NSString *)name{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionaries" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@ and profile= %@ ", name, _currentProfile];
    [request setPredicate:pred];
    
    NSError *error = nil;
    TCDictionariesModel *fetchResult = nil;
    fetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    return fetchResult;
}

- (void)addDictionary:(NSString*)name{
    //не может быть
    if (_currentProfile == nil) return;
    TCDictionariesModel *dictionary=[self getDictionaryWithName:name];
    if (dictionary==nil){
        TCDictionariesModel *tcdm = (TCDictionariesModel*)[NSEntityDescription insertNewObjectForEntityForName:@"Dictionaries" inManagedObjectContext:[self managedObjectContext]];
        [tcdm setName:name];
        [tcdm setProfile:_currentProfile];
        _currentDictionary = tcdm;
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
            NSLog(@"Dictionary add error: %@", error);
        }
        NSLog(@"Dictionary add: %@", name);
    } else {
        NSLog(@"Dictionary name %@ found one", name);
    }
}
- (void)delDictionary:(TCDictionariesModel*)dictionary{
    //переделать на уделение по имени
    [[self managedObjectContext] deleteObject:dictionary];
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}
- (void)updateDictionary:(TCDictionariesModel*)dictionary{
    //обновление только текущего словаря или нужно передавать два словаря в процедуру/ не нужно только текущего/
    if (_currentProfile == nil) return;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionaries"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self == %@", _currentDictionary];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) { //it's true always
        for (NSManagedObject *obj in array) {
            [obj setValue:dictionary.name forKey:@"name"];
            [obj setValue:dictionary.originalLanguage forKey:@"originalLanguage"];
            [obj setValue:dictionary.translationLanguage forKey:@"translationLanguage"];
        }
    }
    _currentDictionary.name = dictionary.name;
    _currentDictionary.originalLanguage = dictionary.originalLanguage;
    _currentDictionary.translationLanguage = dictionary.translationLanguage;
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}

- (void)setCurrentDictionary:(TCDictionariesModel*)dictionary{
    _currentDictionary = dictionary;
}

- (NSArray*)getDictionaries{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionaries" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"profile = %@ ", _currentProfile];
    [request setPredicate:pred];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    NSLog(@"Dictionaries count: %d of profile name %@", mutableFetchResults.count, _currentProfile.name);
    return mutableFetchResults;
    //[[NSArray alloc] initWithArray:mutableFetchResults copyItems:TRUE];
    mutableFetchResults = nil;
}

//управление перечнем языков

- (TCLanguagesModel*)getLanguageWithName:(NSString *)name{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Languages" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@ and profile= %@ ", name, _currentProfile];
    [request setPredicate:pred];
    
    NSError *error = nil;
    TCLanguagesModel *fetchResult = nil;
    fetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    return fetchResult;
}

- (void)addLanguage:(NSString*)name{
    TCLanguagesModel *language=[self getLanguageWithName:name];
    if (language==nil){
        TCLanguagesModel *tclm = (TCLanguagesModel*)[NSEntityDescription insertNewObjectForEntityForName:@"Languages" inManagedObjectContext:[self managedObjectContext]];
        [tclm setName:name];
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
            NSLog(@"Language add error: %@", error);
        }
        NSLog(@"Language add: %@", name);
    } else {
        NSLog(@"Language name %@ found one", name);
    }
    
}
- (void)delLanguage:(TCLanguagesModel*)language{
    //переделать на уделение по имени
    [[self managedObjectContext] deleteObject:language];
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}
- (void)updateLanguage:(TCLanguagesModel*)language withNewName:(NSString*)newName{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Languages"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self == %@", language];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) { //it's true always
        for (NSManagedObject *obj in array) {
            [obj setValue:newName forKey:@"name"];
        }
    }
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}
- (NSArray*)getLanguages{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Languages" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    NSLog(@"Languages count: %d ", mutableFetchResults.count);
    return mutableFetchResults;
    //[[NSArray alloc] initWithArray:mutableFetchResults copyItems:TRUE];
    mutableFetchResults = nil;
}

//управление перечнем слов

- (TCWordsModel*)getWordWithName:(NSString *)name{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Words" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"word = %@ and dictionary= %@ ", name, _currentDictionary];
 //   NSPredicate *pred = [NSPredicate predicateWithFormat:@"word = %@ ", name];
    [request setPredicate:pred];
    
    NSError *error = nil;
    TCWordsModel *fetchResult = nil;
    fetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    return fetchResult;
}

- (void)addWord:(NSString*)name withTranslation:(NSString*)translation withOtherForms:(NSString*)otherForm{
    TCWordsModel *word=[self getWordWithName:name];
    if (word==nil){
        TCWordsModel *tcwm = (TCWordsModel*)[NSEntityDescription insertNewObjectForEntityForName:@"Words" inManagedObjectContext:[self managedObjectContext]];
        [tcwm setWord:name];
        [tcwm setTranslation:translation];
        [tcwm setOtherForms:otherForm];
        [tcwm setDictionary:_currentDictionary];
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
            NSLog(@"Word add error: %@", error);
        }
        NSLog(@"Word add: %@", name);
    } else {
        //just update isMastered (and update word??)
        [self updateWord:word withName:name withTranslation:translation withOtherForms:otherForm];
        NSLog(@"Word name %@ found one. updated", name);
    }
}
- (void)delWord:(TCWordsModel*)word{
    [[self managedObjectContext] deleteObject:word];
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}
- (void)updateWord:(TCWordsModel*)word withName:(NSString*)name withTranslation:(NSString*)translation withOtherForms:(NSString*)otherForms{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Words"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self == %@", word];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) { //it's true always
        for (NSManagedObject *obj in array) {
            [obj setValue:name forKey:@"word"];
            [obj setValue:translation forKey:@"translation"];
            [obj setValue:otherForms forKey:@"otherForms"];
            [obj setValue:false forKey:@"isMastered"];
        }
    }
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}
- (NSArray*)getWords{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Words" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"dictionary = %@ ", _currentDictionary];
    [request setPredicate:pred];
    //пока сортировка по алфавиту
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    NSLog(@"Word count: %d of dictionary name %@", mutableFetchResults.count, _currentDictionary.name);
    return mutableFetchResults;
    //[[NSArray alloc] initWithArray:mutableFetchResults copyItems:TRUE];
    mutableFetchResults = nil;
}


@end
