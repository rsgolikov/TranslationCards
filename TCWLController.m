//
//  TCWLController.m
//  TranslationCards
//
//  Created by Баз Светик on 28.08.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import "TCWLController.h"
#import "TCWordsModel.h"

@implementation TCWLController

- (TCWordsModel*) getNextWord{
    TCWordsModel* word = [[TCWordsModel alloc] init];
    return word;
}
- (TCWordsModel*) getPrevWord{
    TCWordsModel* word = [[TCWordsModel alloc] init];
    return word;
}

@end
