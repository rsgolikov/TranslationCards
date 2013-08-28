//
//  TCWLController.h
//  TranslationCards
//
//  Created by Баз Светик on 28.08.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Words.h"

@interface TCWLController : NSObject
- (Words*) getNextWord;
- (Words*) getPrevWord;
@end
