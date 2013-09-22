//
//  TranslationCardsTests.m
//  TranslationCardsTests
//
//  Created by user6230 on 8/28/13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import "TranslationCardsTests.h"
#import "TCDBController.h"

@interface TranslationCardsTests ()
@property TCDBController *dbController;
@end
@implementation TranslationCardsTests

- (void)setUp
{
  [super setUp];
  self.dbController = [[TCDBController alloc] init];
    [self.dbController delAll];

  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

- (void)testDBControllerProfiles
{
    STAssertTrue([[self.dbController getWords] count]==0, @"at the begin word count=0");
    STAssertTrue([[self.dbController getDictionaries] count]==0, @"at the begin dictionaries count=0");
    STAssertTrue([[self.dbController getLanguages] count]==0, @"at the begin languages count=0");
    STAssertTrue([[self.dbController getProfiles] count] == 0,
               @"At the begin of testDBControllerProfiles list of profiles should be empty");
    NSString *wordOne=@"word one";
    NSString *langOne = @"lang one";
    NSString *dictOne = @"Dict one";
    NSString *dictTwo = @"Dict two";
    NSString *dictThree = @"Dict three";
    NSString *profileNameOne = @"profile One";
    NSString *profileNameTwo = @"profile Two";
    
    //profiles
    [self.dbController delAll];
    [self.dbController addProfile:nil];
    STAssertTrue([[self.dbController getProfiles] count] == 0, @"nil profile can't be added");
    [self.dbController addProfile:profileNameOne];
    STAssertTrue(self.dbController.currentProfile != nil,@"After adding currentProfile should be set to object");
    TCProfileModel *profile1 = self.dbController.currentProfile;
    STAssertTrue(profile1.name == profileNameOne, @"addProfile should set added profile as current");
    STAssertTrue([[self.dbController getProfiles] count] == 1, @"profile added as one profile");
    [self.dbController addProfile:profileNameOne];
    STAssertTrue([[self.dbController getProfiles] count] == 1, @"If profile with this name already exists we should return it instead of insert new one");
    STAssertTrue(profile1 == self.dbController.currentProfile, @"Adding new profile with existing name should not create a new copy of TCProfileModel");
    [self.dbController delProfile:nil];
    STAssertTrue([[self.dbController getProfiles] count] == 1, @"nil profile can't delete real profile");
    [self.dbController updateProfile:nil];
    STAssertTrue([[self.dbController getProfiles] count] == 1, @"nil profile can't update real profile");
    [self.dbController updateProfile:profile1];
    STAssertTrue([[self.dbController getProfiles] count] == 1, @"same profile can't be added");
    STAssertTrue(profile1 == self.dbController.currentProfile, @"after update itself point not changed");
    [self.dbController delProfile:[self.dbController currentProfile]];
    STAssertTrue([[self.dbController getProfiles] count] == 0, @"after delete last profile count=0");
    STAssertTrue(self.dbController.currentProfile == nil,@"After deleting all objects currentProfile should be set to nil");
    [self.dbController addProfile:profileNameOne];
    profile1 = [self.dbController currentProfile];
    [self.dbController addProfile:profileNameTwo];
    STAssertTrue([self.dbController currentProfile]  != profile1, @"after add new profile current profile must be changed");
    [self.dbController delProfile:[self.dbController currentProfile]];
    STAssertTrue([self.dbController currentProfile]  == profile1, @"after del profile current profile must be changed");

    
    //dictionaries
    [self.dbController delAll];
    [self.dbController addDictionary:dictOne];
    STAssertTrue([[self.dbController getDictionaries] count]==0, @"with empty profile dictionary can't add");
    [self.dbController addProfile:profileNameOne];
    [self.dbController addDictionary:nil];
    STAssertTrue([[self.dbController getDictionaries] count]==0, @"empty dictionary can't be added");
    [self.dbController addDictionary:dictOne];
    STAssertTrue([[self.dbController getDictionaries] count]==1, @"dictionary added as one dictionary");
    [self.dbController addDictionary:dictOne];
    STAssertTrue([[self.dbController getDictionaries] count]==1, @"same dictionary not added just selected");
    [self.dbController delProfile:[self.dbController currentProfile]];
    STAssertTrue([[self.dbController getAllDictionaries] count]==0, @"cascade delete not working");
    [self.dbController addProfile:profileNameOne];
    [self.dbController addDictionary:dictOne];
    [self.dbController addProfile:profileNameTwo];
    [self.dbController addDictionary:dictTwo];
    [self.dbController addDictionary:dictThree];
    [self.dbController delProfile:[self.dbController currentProfile]];
    STAssertTrue([[self.dbController getAllDictionaries] count]==1, @"cascade delete not working");
    [self.dbController addProfile:profileNameTwo];
    [self.dbController addDictionary:dictTwo];
    TCDictionariesModel *tcdm = [self.dbController currentDictionary];
    [self.dbController addDictionary:dictThree];
    STAssertTrue([self.dbController currentDictionary]  != tcdm, @"after add current dictionary must be changed");
    tcdm = [self.dbController currentDictionary];
    [self.dbController delDictionary:[self.dbController currentDictionary]];
    STAssertTrue([self.dbController currentDictionary]  != tcdm, @"after del current dictionary must be changed");
    STAssertTrue([[self.dbController getDictionaries] count]==1, @"wrong delete??");
    STAssertTrue([[self.dbController getProfiles] count]==2, @"wrong cascade delete??");
    STAssertTrue(self.dbController.currentDictionary!= nil,@"After deleting not all objects currentDictionary can't be nil");
     
    //words
    [self.dbController delAll];
    [self.dbController addProfile:profileNameOne];
    [self.dbController addDictionary:dictOne];
    [self.dbController addWord:wordOne withTranslation:nil withOtherForms:nil];
    STAssertTrue([[self.dbController getWords] count]==0, @"empty translation can't add");
    [self.dbController addWord:wordOne withTranslation:@" один " withOtherForms:nil];
    STAssertTrue([[self.dbController getWords] count]==1, @"added not working ");
    [self.dbController addWord:wordOne withTranslation:@" один " withOtherForms:nil];
    STAssertTrue([[self.dbController getWords] count]==1, @"if have word in list it must be updated not added");
    [self.dbController updateWord:[self.dbController getLastWord] withName:@"two" withTranslation:nil withOtherForms:nil];
    TCWordsModel *tcwm = [self.dbController getLastWord];
    STAssertTrue([[self.dbController getWords] count]==1, @"update not working ");
    STAssertTrue([self.dbController getLastWord] ==tcwm, @"update2 not working ");
    STAssertTrue([[self.dbController getLastWord] word] !=wordOne, @"update3 not working ");
    [self.dbController delDictionary:[self.dbController currentDictionary]];
    STAssertTrue([[self.dbController getAllWords] count]==0, @"cascade delete dictionary not working ");
    STAssertTrue([[self.dbController getProfiles] count]==1, @"cascade delete dictionary not working ");
    
    [self.dbController addProfile:profileNameOne];
    [self.dbController addDictionary:dictOne];
    [self.dbController addWord:wordOne withTranslation:@" один " withOtherForms:nil];
    [self.dbController delProfile:[self.dbController currentProfile]];
    STAssertTrue([[self.dbController getAllWords] count]==0, @"cascade delete profile not working ");
  
 }

@end
