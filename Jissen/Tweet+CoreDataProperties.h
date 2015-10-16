//
//  Tweet+CoreDataProperties.h
//  Jissen
//
//  Created by Satoru Sasozaki on 10/15/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;

@end

NS_ASSUME_NONNULL_END
