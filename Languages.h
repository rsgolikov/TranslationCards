//
//  Languages.h
//  TranslationCards
//
//  Created by Баз Светик on 28.08.13.
//  Copyright (c) 2013 SS United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Languages : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * id;

@end
