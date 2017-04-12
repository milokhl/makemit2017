//
//  objectUniqueIDAssigner.h
//  TapNote 2
//
//  Created by Magnus Johnson on 10/21/16.
//  Copyright © 2016 MagMHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface objectUniqueIDAssigner : NSObject {
    int maxIDUsed;
}

- (int)generateNewIDForObject;
+ (id)sharedInstance;
- (id)modifiedInit;

@end
