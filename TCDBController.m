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
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = '%@' ", name];
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
        self.currentProfile = tcpfm;
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
    if (self.currentProfile == nil) return;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profiles"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self == %@", self.currentProfile];
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
    if (self.currentProfile == nil) return;
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

- (TCProfileModel*)getDictionaryWithName:(NSString *)name{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionaries" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = '%@' ", name];
    [request setPredicate:pred];
    
    NSError *error = nil;
    TCProfileModel *fetchResult = nil;
    fetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    return fetchResult;
}

- (void)addDictionary:(NSString*)name{
    TCProfileModel *profile=[self getProfileWithName:name];
    if (profile==nil){
        TCDictionariesModel *tcdm = (TCDictionariesModel*)[NSEntityDescription insertNewObjectForEntityForName:@"Dictionaries" inManagedObjectContext:[self managedObjectContext]];
        [tcdm setName:name];
        [tcdm setProfile:self.currentProfile];
        self.currentDictionary = tcdm;
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
    //обновление только текущего профиля или нужно передавать два профиля в процедуру/ не нужно только текущего/
    if (self.currentProfile == nil) return;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionaries"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self == %@", self.currentProfile];
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
    if (![[self managedObjectContext] save:&error]) {
        // Handle the error.
    }
}

- (void)setCurrentDictionary:(TCDictionariesModel*)dictionary{
    self.currentDictionary = dictionary;
}

- (NSArray*)getDictionaries{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionaries" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"profile = %@ ", self.currentProfile];
    [request setPredicate:pred];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    NSLog(@"Dictionaries count: %d of profile name %@", mutableFetchResults.count, self.currentProfile.name);
    return mutableFetchResults;
    //[[NSArray alloc] initWithArray:mutableFetchResults copyItems:TRUE];
    mutableFetchResults = nil;
}

//управление перечнем языков
- (void)addLanguage:(NSString*)name{
    
}
- (void)delLanguage:(TCLanguagesModel*)language{
    
}
- (void)updateLanguage:(TCLanguagesModel*)language{
    
}
- (NSArray*)getLanguages{
    NSArray *dummy = [[NSArray alloc] initWithObjects:@"getLanguages", nil];
    return dummy;
}

//управление перечнем слов
- (void)addWord:(NSString*)word withTranslate:(NSString*)translate withOtherForms:(NSString*)form{
    
}
- (void)delWord:(TCWordsModel*)word{
    
}
- (void)updateWord:(TCWordsModel*)word{
    
}
- (NSArray*)getWords{
    NSArray *dummy = [[NSArray alloc] initWithObjects:@"getWords", nil];
    return dummy;
}


@end
