//
//  TCModelController.h
//  TranslationCards
//
//  Created by user6230 on 8/28/13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCDataViewController;

@interface TCModelController : NSObject <UIPageViewControllerDataSource>

- (TCDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(TCDataViewController *)viewController;

@end
