//
//  Status+CoreDataProperties.h
//  LayerTest
//
//  Created by w99wen on 16/6/26.
//  Copyright © 2016年 w99wen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Status.h"

NS_ASSUME_NONNULL_BEGIN

@interface Status (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSNumber *signSum;
@property (nullable, nonatomic, retain) NSManagedObject *user;
@property (nullable, nonatomic, retain) NSManagedObject *invitedUser;

@end

NS_ASSUME_NONNULL_END
