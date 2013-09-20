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
  
  for (TCProfileModel *profile in self.dbController.getProfiles) {
    [self.dbController delProfile:profile];
  }

  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

- (void)testDBControllerProfiles
{
  STAssertTrue([[self.dbController getProfiles] count] == 0,
               @"At the begin of testDBControllerProfiles list of profiles should be empty");
  
  NSString *profileName1 = @"One";
  
  [self.dbController addProfile:profileName1];
  TCProfileModel *profile1 = self.dbController.currentProfile;
  
  STAssertTrue(profile1.name == profileName1, @"addProfile should set added profile as current");
  [self.dbController addProfile:profileName1];
  STAssertTrue([[self.dbController getProfiles] count] == 1,
               @"If profile with this name already exists we should return it instead of insert new one");
  STAssertTrue(profile1 == self.dbController.currentProfile,
               @"Adding new profile with existing name should not create a new copy of TCProfileModel");
  
  [self.dbController delProfile:profile1];

  STAssertTrue([[self.dbController getProfiles] count] == 0,
               @"After deleting inserted item list of profiles should be empty");
  
  STAssertTrue(self.dbController.currentProfile == nil,
               @"After deleting all objects currentProfile should be set to nil");

  [self.dbController addProfile:profileName1];
  STAssertTrue(profile1 == self.dbController.currentProfile,
               @"Newly inserted profile should not be equal to deleted one");
}

@end
