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
    /*
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profiles"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id = %d", (int)profile.id]];
    [request setPredicate:pred];
    
    NSArray *queryArray=[self.managedObjectContext executeFetchRequest:request error:nil];

    if ([queryArray count] > 0){
        TCProfileModel *tcpfm = [queryArray objectAtIndex:0];
        tcpfm.name = profile.name;
        tcpfm.isCurrent = profile.isCurrent;
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
        }
    }
     */
}
- (void)setCurrentProfile:(TCProfileModel*)profile;{
    /*
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profiles"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"isCurrent = 1"]];
    [request setPredicate:pred];
    
    NSArray *queryArray=[self.managedObjectContext executeFetchRequest:request error:nil];
    if ([queryArray count] > 0){
        TCProfileModel *tcpfm = [queryArray objectAtIndex:0];
        tcpfm.isCurrent = [NSNumber numberWithInt:0];
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
        }
    }
    pred = nil;
    queryArray = nil;
    
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id = %d", (int)profile.id]];
    [request setPredicate:pred2];
    
    NSArray *queryArray2=[self.managedObjectContext executeFetchRequest:request error:nil];
    
    if ([queryArray2 count] > 0){
        TCProfileModel *tcpfm = [queryArray2 objectAtIndex:0];
        tcpfm.isCurrent = [NSNumber numberWithInt:0];
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
        }
    }
     */
    
}

- (void)setDefaultProfileSettings:(TCProfileModel*)profile{
  //ощущение что делаю через одно место.. пропустим надо обсудить
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
- (void)addDictionary:(NSString*)name{
    
}
- (void)delDictionary:(TCDictionariesModel*)dictionary{
    
}
- (void)updateDictionary:(TCDictionariesModel*)dictionary{
    
}
- (void)setCurrentDictionary:(TCDictionariesModel*)dictionary{
    
}
- (NSArray*)getDictionaries{
    NSArray *dummy = [[NSArray alloc] initWithObjects:@"getDictionaries", nil];
    return dummy;
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
