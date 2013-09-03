//
//  TCWLController.h
//  TranslationCards
//
//  Created by Баз Светик on 28.08.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCWordsModel.h"

@interface TCWLController : NSObject
- (TCWordsModel*) getNextWord;
- (TCWordsModel*) getPrevWord;
@end
